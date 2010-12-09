using System;
using System.Collections.Generic;
using System.Data.Odbc;
using System.Data.SqlClient;
using System.Linq;
using System.Net;
using System.Text;
using System.Text.RegularExpressions;
using System.Web;

using Arena.Core;
using Arena.Phone;

namespace Arena.Custom.HDC.Asterisk
{
    public class AsteriskPBXManager : PBXManager
    {
        // Properties
        private Guid _sessionGuid = Guid.NewGuid();

        public int OrganizationId { get; set; }
        public string Password { get; set; }
        public int Port { get; set; }
        public string ServerName { get; set; }
        public string Username { get; set; }

        // Methods
        public bool Originate(string channel, string context, string phoneNumber, string callerId)
        {
            bool result = true;
            String hostName, phoneAddress = "";
            HttpWebRequest request;

            try
            {
                hostName = Dns.GetHostEntry(HttpContext.Current.Request.UserHostAddress).HostName;

                OdbcConnection odbc = new OdbcConnection("DSN=Asterisk");
                odbc.Open();
                OdbcCommand cmd = odbc.CreateCommand();

                cmd.CommandText = "SELECT ipaddr FROM sip WHERE desktop = ?";
                cmd.Parameters.Clear();
                cmd.Parameters.Add(new OdbcParameter("@Hostname", hostName));
                phoneAddress = (String)cmd.ExecuteScalar();

                odbc.Close();

                request = (HttpWebRequest)HttpWebRequest.Create("http://" + phoneAddress + "/index.htm?number=" + phoneNumber);
                request.GetResponse();
            }
            catch { }

            return result;
        }

        public CDRCollection GetCDRRecords()
        {
            CDRCollection cdrRecords = new CDRCollection();
            SqlDataReader rdr;


            //
            // Open the Asterisk Database.
            //
            rdr = new Arena.DataLayer.Organization.OrganizationData().ExecuteReader("cust_asterisk_sp_get_cdr_records");
            while (rdr.Read())
            {
                CDR cdr = new CDR();

                string srcChannel = rdr["channel"].ToString();
                if (srcChannel.ToUpper().StartsWith("SIP/"))
                {
                    cdr.Source = srcChannel.Substring(4);
                    cdr.Source = cdr.Source.Substring(0, cdr.Source.IndexOf('-'));
                }
                else
                    cdr.Source = rdr["src"].ToString();

                string dstChannel = rdr["dstchannel"].ToString();
                if (dstChannel.ToUpper().StartsWith("SIP/"))
                {
                    cdr.Destination = dstChannel.Substring(4);
                    cdr.Destination = cdr.Destination.Substring(0, cdr.Destination.IndexOf('-'));
                }
                else
                    cdr.Destination = rdr["dst"].ToString();
                if (cdr.Destination.Length >= 7 && cdr.Destination[0] != '9')
                    cdr.Destination = "9" + cdr.Destination; // Prepend a 9 for outward calls that don't have it.
                if (cdr.Destination.Length > 7 && cdr.Destination.Substring(0, 2) == "91")
                    cdr.Destination = "9" + cdr.Destination.Substring(2); // Strip out the 1 for long distance

                cdr.CallerID = rdr["clid"].ToString();

                if (!rdr.IsDBNull(rdr.GetOrdinal("start")))
                    cdr.CallStart = (DateTime)rdr["start"];

                if (!rdr.IsDBNull(rdr.GetOrdinal("answer")))
                    cdr.Answered = (DateTime)rdr["answer"];

                if (!rdr.IsDBNull(rdr.GetOrdinal("end")))
                    cdr.CallEnd = (DateTime)rdr["end"];

                if (!rdr.IsDBNull(rdr.GetOrdinal("duration")))
                    cdr.Duration = Convert.ToInt32(rdr["duration"]);

                if (!rdr.IsDBNull(rdr.GetOrdinal("billsec")))
                    cdr.BillSeconds = Convert.ToInt32(rdr["billsec"]);

                if (!rdr.IsDBNull(rdr.GetOrdinal("disposition")))
                {
                    switch (rdr["disposition"].ToString())
                    {
                        case "ANSWERED": cdr.Disposition = CDR_Disposition.Answered; break;
                        case "NO ANSWER": cdr.Disposition = CDR_Disposition.No_Answer; break;
                        case "BUSY": cdr.Disposition = CDR_Disposition.Busy; break;
                        case "FAILED": cdr.Disposition = CDR_Disposition.Failed; break;
                    }
                }

                cdr.ForeignKey = rdr["uniqueid"].ToString();

                cdrRecords.Add(cdr);
            }
            rdr.Close();

            return cdrRecords;
        }


        public void SyncPeers(int organizationId)
        {
            OdbcConnection odbc;
            OdbcDataReader rdr;
            OdbcCommand cmd;

            LookupCollection extensionRules = new LookupType(SystemLookupType.PhoneInternalExtensionRules).Values;

            //
            // Open the Asterisk Database.
            //
            odbc = new OdbcConnection("DSN=Asterisk");
            odbc.Open();
            cmd = odbc.CreateCommand();

            cmd.CommandText = "SELECT name,host,nat,ipaddr FROM sip";
            rdr = cmd.ExecuteReader();
            while (rdr.Read())
            {
                SavePeer(organizationId,
                    extensionRules,
                    rdr["name"].ToString(),
                    false,
                    (rdr["host"].ToString() == "dynamic"),
                    (rdr["nat"].ToString() == "yes"),
                    rdr["ipaddr"].ToString(),
                    "SIP");
            }
            rdr.Close();
            odbc.Close();
        }

        public void GetFollowMeNumber(Guid phoneType, string phoneNumber, out string personalChannel, out string personalContext) { personalChannel = null; personalContext = null; }
        public List<Voicemail> GetPersonVoicemails(Person person) { return null; }
        public void DeleteVoicemail(int VoiceMailID) { }
        public List<Voicemail> GetVoicemail() { return null; }
        public Voicemail GetVoicemail(Guid guid) { return null; }
        public VoicemailConfig GetVoicemailConfiguration(string objectName) { return null; }
        public void MarkVoicemailProcessed(int VoiceMailID) { }
        public void MarkVoicemailRead(int VoiceMailID) { }
        public void SaveVoicemailConfiguration(string objectName, VoicemailConfig voicemailConfig) { }
        public bool VoicemailExists(int VoiceMailID) { return false; }


        #region Private methods

        private void SavePeer(int organizationId, LookupCollection extensionRules, string objectName, bool acl, bool dynamic, bool natSupport, string ip, string type)
        {
            string internalNumber = objectName;

            foreach (Lookup rule in extensionRules)
                if (Regex.Match(objectName, rule.Qualifier).Success)
                    if (rule.Qualifier3 != string.Empty)
                        internalNumber = rule.Qualifier3.Replace("##orig##", objectName);

            // find linked people
            PersonCollection peerPersons = new PersonCollection();
            peerPersons.LoadByPhone(internalNumber);
            
            if (peerPersons.Count > 0)
            {
                Arena.Phone.Peer peer = new Arena.Phone.Peer(objectName);
                peer.PersonId = peerPersons[0].PersonID;
                peer.Acl = acl;
                peer.Dynamic = dynamic;
                peer.NatSupport = natSupport;
                peer.Ip = ip;
                peer.ObjectName = objectName;
                peer.Type = type;
                peer.OrganizationId = organizationId;
                peer.InternalNumber = internalNumber;
                peer.LastAuditId = _sessionGuid;
                peer.Save("voipManager");
            }
        }
        
        #endregion

    }
}
