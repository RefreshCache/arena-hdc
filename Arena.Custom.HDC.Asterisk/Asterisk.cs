using System;
using System.Collections;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Net;
using System.Text;
using System.Text.RegularExpressions;
using System.Xml;

using Arena.Core;
using Arena.Exceptions;
using Arena.Phone;

namespace Arena.Custom.CCV.Phone
{
    public class Asterisk : PBXManager
    {
        #region Private Members

        private CookieContainer _cookieContainer = null;

        private string _serverName;
        private string _password;
        private string _username;
        private int _port = 5038;
        private Guid _sessionGuid = Guid.NewGuid();
        private int _organizationId = -1;

        #endregion

        # region Properties

        public string ServerName
        {
            get { return _serverName; }
            set { _serverName = value; }
        }

        public string Password
        {
            get { return _password; }
            set { _password = value; }
        }

        public string Username
        {
            get { return _username; }
            set { _username = value; }
        }

        public int Port
        {
            get { return _port; }
            set { _port = value; }
        }

        public int OrganizationId
        {
            get { return _organizationId; }
            set { _organizationId = value; }
        }

        #endregion

        #region Public Methods

        public bool Originate(string channel, string context, string phoneNumber, string callerId)
        {
            bool result = false;

            XmlDocument xdoc = AJAMRequest(string.Format("http://{0}:{1}/asterisk/mxml?action=Login&username={2}&secret={3}",
                _serverName, _port, _username, _password));

            if (xdoc != null)
            {
                if (AJAMResponse(xdoc) == "Success")
                {
                    xdoc = AJAMRequest(string.Format("http://{0}:{1}/asterisk/mxml?action=Originate&channel={2}&exten={3}&context={4}&Priority=1&CallerID={5}",
                        _serverName, _port, channel, phoneNumber, context, callerId));

                    if (xdoc != null)
                    {
                        if (AJAMResponse(xdoc) == "Success")
                            result = true;
                        else
                            throw new ArenaApplicationException(string.Format("Error occurred while attempting to originate a call with Asterisk server: {0}", AJAMMessage(xdoc)));
                    }
                    else
                        throw new ArenaApplicationException("Error occurred while attempting to originate a call with Asterisk server: Request did not return an XML response.");

                    AJAMRequest(string.Format("http://{0}:{1}/asterisk/mxml?action=Logoff",
                        _serverName, _port));
                }
                else 
                    throw new ArenaApplicationException(string.Format("Error occurred while attempting to login to Asterisk server: {0}", AJAMMessage(xdoc)));
            }
            else
                throw new ArenaApplicationException("Error occurred while attempting to login to Asterisk server: Request did not return an XML response.");

            return result;
        }

        public string GetContext(int phoneTypeId)
        {
            string context = string.Empty;

            //SystemLookup.

            return context;
        }

        public void SyncPeers(int organizationId)
        {
            Organization.Organization organization = new Arena.Organization.Organization(organizationId);
            string syncPeersSQL = organization.Settings["AsteriskPeerSyncSQL"];

            LookupCollection extensionRules = new LookupType(SystemLookupType.PhoneInternalExtensionRules).Values;

            if (syncPeersSQL != null)
            {
                SqlDataReader rdr = new Arena.DataLayer.Organization.OrganizationData().ExecuteReader(syncPeersSQL);
                while (rdr.Read())
                    SavePeer(
                        organizationId,
                        extensionRules,
                        rdr["name"].ToString(),
                        false,
                        rdr["host"].ToString() == "dynamic",
                        rdr["nat"].ToString() != "no",
                        rdr["ipaddr"].ToString(),
                        "SIP");
                rdr.Close();
            }
            else
            {
                XmlDocument xdoc = AJAMRequest(string.Format("http://{0}:{1}/asterisk/mxml?action=Login&username={2}&secret={3}",
                    _serverName, _port, _username, _password));

                if (xdoc != null)
                {
                    if (AJAMResponse(xdoc) == "Success")
                    {
                        xdoc = AJAMRequest(string.Format("http://{0}:{1}/asterisk/mxml?action=SIPPeers",
                            _serverName, _port));

                        AJAMRequest(string.Format("http://{0}:{1}/asterisk/mxml?action=Logoff",
                            _serverName, _port));

                        if (xdoc != null)
                        {
                            if (AJAMResponse(xdoc) == "Success")
                            {
                                XmlNodeList nodes = xdoc.DocumentElement.SelectNodes("response/generic[@event='PeerEntry']");
                                foreach (XmlNode node in nodes)
                                {
                                    SavePeer(
                                        organizationId,
                                        extensionRules,
                                        XmlAttributeValue(node, "objectname"),
                                        XmlAttributeValue(node, "acl") != "no",
                                        XmlAttributeValue(node, "dynamic") != "no",
                                        XmlAttributeValue(node, "natsupport") != "no",
                                        XmlAttributeValue(node, "ipaddress"),
                                        XmlAttributeValue(node, "chanobjecttype"));
                                }
                            }
                            else
                                throw new ArenaApplicationException(string.Format("Error occurred while attempting to originate a call with Asterisk server: {0}", AJAMMessage(xdoc)));
                        }
                        else
                            throw new ArenaApplicationException("Error occurred while attempting to originate a call with Asterisk server: Request did not return an XML response.");
                    }
                    else
                        throw new ArenaApplicationException(string.Format("Error occurred while attempting to login to Asterisk server: {0}", AJAMMessage(xdoc)));
                }
                else
                    throw new ArenaApplicationException("Error occurred while attempting to login to Asterisk server: Request did not return an XML response.");
            }

            new Arena.DataLayer.Phone.PeerData().DeletePeerOutdated(_sessionGuid);
        }

        public CDRCollection GetCDRRecords()
        {
            CDRCollection cdrRecords = new CDRCollection();

            SqlDataReader rdr = new Arena.DataLayer.Organization.OrganizationData().ExecuteReader("cust_asterisk_sp_get_cdr_records");
            while (rdr.Read())
            {
                CDR cdr = new CDR();

                string srcChannel = rdr["channel"].ToString();
                if (srcChannel.ToUpper().StartsWith("SIP/"))
                    cdr.Source = srcChannel.Substring(4, 4);
                else
                    cdr.Source = rdr["src"].ToString();
                
                string dstChannel = rdr["dstchannel"].ToString();
                if (dstChannel.ToUpper().StartsWith("SIP/"))
                    cdr.Destination = dstChannel.Substring(4, 4);
                else
                    cdr.Destination = rdr["dst"].ToString();

                cdr.CallerID = rdr["clid"].ToString();

                if (!rdr.IsDBNull(rdr.GetOrdinal("start")))
                    cdr.CallStart = (DateTime)rdr["start"];

                if (!rdr.IsDBNull(rdr.GetOrdinal("answer")))
                    cdr.Answered = (DateTime)rdr["answer"];

                if (!rdr.IsDBNull(rdr.GetOrdinal("end")))
                    cdr.CallEnd = (DateTime)rdr["end"];

                if (!rdr.IsDBNull(rdr.GetOrdinal("duration")))
                    cdr.Duration = (int)rdr["duration"];

                if (!rdr.IsDBNull(rdr.GetOrdinal("billsec")))
                    cdr.BillSeconds = (int)rdr["billsec"];

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

        public VoicemailConfig GetVoicemailConfiguration(string objectName)
        {
            VoicemailConfig voicemailConfig = null;

            ArrayList lst = new ArrayList();
            lst.Add(new SqlParameter("@MailBoxUser", objectName));

            try
            {
                SqlDataReader rdr = new Arena.DataLayer.Organization.OrganizationData().ExecuteReader("cust_asterisk_sp_get_configuration", lst);
                if (rdr.Read())
                {
                    voicemailConfig = new VoicemailConfig(
                        (bool)rdr["send_email"],
                        (bool)rdr["delete_when_emailed"]);
                }
                rdr.Close();
            }
            catch 
            {
                voicemailConfig = new VoicemailConfig(false, false);
            }

            return voicemailConfig;
        }

        public void SaveVoicemailConfiguration(string objectName, VoicemailConfig voicemailConfig)
        {
            ArrayList lst = new ArrayList();
            lst.Add(new SqlParameter("@MailBoxUser", objectName));
            lst.Add(new SqlParameter("@SendEmail", voicemailConfig.SendEmail));
            lst.Add(new SqlParameter("@DeleteWhenEmailed", voicemailConfig.DeleteWhenEmailed));

            new Arena.DataLayer.Organization.OrganizationData().ExecuteNonQuery("cust_asterisk_sp_update_configuration", lst);
        }

        public List<Voicemail> GetVoicemail()
        {
            List<Voicemail> voicemails = new List<Voicemail>();

            SqlDataReader rdr = new Arena.DataLayer.Organization.OrganizationData().ExecuteReader("cust_asterisk_sp_get_voicemail_records");
            while (rdr.Read())
            {
                Arena.Phone.Peer peer = new Arena.Phone.Peer(rdr["mailboxuser"].ToString());

                voicemails.Add(new Voicemail(
                    (int)rdr["vm_id"],
                    new Guid(rdr["guid"].ToString()),
                    rdr["dir"].ToString(),
                    rdr["callerid"].ToString(),
                    (DateTime)rdr["date_created"],
                    Int32.Parse(rdr["duration"].ToString()),
                    peer,
                    (byte[])rdr["recording"],
                    (int)rdr["message_type"],
                    (bool)rdr["delete_when_emailed"]));
            }
            rdr.Close();

            return voicemails;
        }

        public Voicemail GetVoicemail(Guid guid)
        {
            Voicemail voicemail = null;

            ArrayList lst = new ArrayList();
            lst.Add(new SqlParameter("@VoiceMailGuid", guid));

            SqlDataReader rdr = new Arena.DataLayer.Organization.OrganizationData().ExecuteReader("cust_asterisk_sp_get_voicemail_by_guid", lst);
            if (rdr.Read())
            {
                Arena.Phone.Peer peer = new Arena.Phone.Peer(rdr["mailboxuser"].ToString());

                voicemail = new Voicemail(
                    (int)rdr["vm_id"],
                    new Guid(rdr["guid"].ToString()),
                    rdr["dir"].ToString(),
                    rdr["callerid"].ToString(),
                    (DateTime)rdr["date_created"],
                    Int32.Parse(rdr["duration"].ToString()),
                    peer,
                    (byte[])rdr["recording"],
                    (int)rdr["message_type"],
                    (bool)rdr["delete_when_emailed"]);
            }
            rdr.Close();

            return voicemail;
        }

        public List<Voicemail> GetPersonVoicemails(Person person)
        {
            List<Voicemail> voicemails = new List<Voicemail>();

            if (person.Peers.Count > 0)
            {
                try
                {
                    ArrayList lst = new ArrayList();
                    lst.Add(new SqlParameter("@MailBoxUser", person.Peers[0].ObjectName));

                    SqlDataReader rdr = new Arena.DataLayer.Organization.OrganizationData().ExecuteReader("cust_asterisk_sp_get_voicemails", lst);
                    while (rdr.Read())
                    {
                        Arena.Phone.Peer peer = new Arena.Phone.Peer(rdr["mailboxuser"].ToString());

                        voicemails.Add(new Voicemail(
                            (int)rdr["vm_id"],
                            new Guid(rdr["guid"].ToString()),
                            rdr["dir"].ToString(),
                            rdr["callerid"].ToString(),
                            (DateTime)rdr["date_created"],
                            Int32.Parse(rdr["duration"].ToString()),
                            peer,
                            (byte[])rdr["recording"],
                            (int)rdr["message_type"],
                            (bool)rdr["delete_when_emailed"]));
                    }
                    rdr.Close();
                }
                catch { }
            }
            return voicemails;
        }

        public void MarkVoicemailProcessed(int voiceMailID)
        {
            ArrayList lst = new ArrayList();
            lst.Add(new SqlParameter("@VoiceMailID", voiceMailID));
            new Arena.DataLayer.Organization.OrganizationData().ExecuteNonQuery("cust_asterisk_sp_voicemail_processed", lst);
        }

        public void MarkVoicemailRead(int voiceMailID)
        {
            ArrayList lst = new ArrayList();
            lst.Add(new SqlParameter("@VoiceMailID", voiceMailID));
            new Arena.DataLayer.Organization.OrganizationData().ExecuteNonQuery("cust_asterisk_sp_voicemail_read", lst);
        }

        public void DeleteVoicemail(int voiceMailID)
        {
            ArrayList lst = new ArrayList();
            lst.Add(new SqlParameter("@VoiceMailID", voiceMailID));
            new Arena.DataLayer.Organization.OrganizationData().ExecuteNonQuery("cust_asterisk_sp_del_voicemail", lst);
        }

        public bool VoicemailExists(int voiceMailID)
        {
            ArrayList lst = new ArrayList();
            lst.Add(new SqlParameter("@VoiceMailID", voiceMailID));

        	try
			{
                object result = new Arena.DataLayer.Organization.OrganizationData().ExecuteScalar("cust_asterisk_sp_get_voicemail_exists", lst);
				if (result != null)
					return (bool)result;
				else
					return false;
			}
			catch (SqlException ex)
			{
				throw ex;
			}
			finally
			{
				lst = null;
			}
        }

        public void GetFollowMeNumber(Guid phoneType, string phoneNumber, out string personalChannel, out string personalContext)
        {
            //string startingChannel = personalChannel ?? "";
            
            if (phoneType.ToString() == "5878fb81-b566-4bf3-b7a5-821303c85a10")
            {
                personalChannel = "sip/" + phoneNumber.Substring(phoneNumber.Length - 4);
                personalContext = "default";
            }
            else
            {
                personalContext = "external";
                personalChannel = "Zap/r1/" + phoneNumber;
            }
            
            
        }

        #endregion

        #region Private Methods

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

        private XmlDocument AJAMRequest(string url)
        {
            if (_cookieContainer == null)
                _cookieContainer = new CookieContainer();

            HttpWebRequest request = (HttpWebRequest)WebRequest.Create(url);
            request.CookieContainer = _cookieContainer;

            XmlDocument xdoc = new XmlDocument();
            xdoc.Load(request.GetResponse().GetResponseStream());

            return xdoc;
        }

        private string AJAMResponse(XmlDocument xdoc)
        {
            XmlNode node = xdoc.DocumentElement.SelectSingleNode("response/generic[@response]");
            if (node != null)
                return node.Attributes["response"].Value;
            else
                return string.Empty;
        }

        private string AJAMMessage(XmlDocument xdoc)
        {
            XmlNode node = xdoc.DocumentElement.SelectSingleNode("response/generic[@response]");
            if (node != null)
                return node.Attributes["message"].Value;
            else
                return string.Empty;
        }

        private string XmlAttributeValue(XmlNode xnode, string attribute)
        {
            if (xnode != null)
            {
                XmlAttribute xattr = xnode.Attributes[attribute];
                if (xattr != null)
                    return xattr.Value;
            }

            return string.Empty;
        }

        #endregion
    }
}
