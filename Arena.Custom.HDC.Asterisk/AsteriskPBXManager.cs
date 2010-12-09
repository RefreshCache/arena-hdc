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
        #region Properties

        //
        // Private properties.
        //
        private Guid _sessionGuid = Guid.NewGuid();

        //
        // Public properties, these are set by the object which loads
        // us in.
        //
        public int OrganizationId { get; set; }
        public string Password { get; set; }
        public int Port { get; set; }
        public string ServerName { get; set; }
        public string Username { get; set; }

        #endregion


        #region Phone Call Methods

        /// <summary>
        /// Initiate a new phone call with the specified information. The channel@context
        /// identifies "who" is calling (i.e. the phone that will be placing the call). The
        /// normal way this works is the channel@context is called first (e.g. SIP/268@staff)
        /// and when the device (phone) is answered the outgoing call begins. So my desk phone
        /// will ring and then when I answer it, it will automatically start dialing out for
        /// me. At HDC we do things differently, see in-line comments.
        /// </summary>
        /// <param name="channel">The channel to use as the source of the phone call, e.g. SIP/268.</param>
        /// <param name="context">The context to put the phone call in, e.g. staff</param>
        /// <param name="phoneNumber">The phone number we will call.</param>
        /// <param name="callerId">The name of the source call. This is usually the name of the person but can be the organization name if the person is unknown.</param>
        /// <returns>true/false state to indicate of the call was initiated or not.</returns>
        public bool Originate(string channel, string context, string phoneNumber, string callerId)
        {
            bool result = true;
            String hostName, phoneAddress = "";
            HttpWebRequest request;

            //
            // Okay, so here is how we do things at HDC. The phones we have (Snom)
            // provide a really powerful web interface. One feature of that interface
            // is to dial directly. We do this via a SQL table on our Asterisk server
            // that associates desktop computer IP addresses with the desktop phone
            // IP address.
            //
            try
            {
                //
                // Lookup the hostname of the desktop computer making the request.
                //
                hostName = Dns.GetHostEntry(HttpContext.Current.Request.UserHostAddress).HostName;

                //
                // Create an ODBC connection to our Asterisk MySQL database.
                //
                OdbcConnection odbc = new OdbcConnection("DSN=Asterisk");
                odbc.Open();
                OdbcCommand cmd = odbc.CreateCommand();

                //
                // Execute a query to find the IP address of the phone. In reality we
                // should do error checking, but in this case we just let the
                // exception handler catch it.
                //
                cmd.CommandText = "SELECT ipaddr FROM sip WHERE desktop = ?";
                cmd.Parameters.Clear();
                cmd.Parameters.Add(new OdbcParameter("@Hostname", hostName));
                phoneAddress = (String)cmd.ExecuteScalar();
                odbc.Close();

                //
                // Create and execute a web request to the phone to begin dialing.
                //
                request = (HttpWebRequest)HttpWebRequest.Create("http://" + phoneAddress + "/index.htm?number=" + phoneNumber);
                request.GetResponse();
            }
            catch
            {
                result = false;
            }

            return result;
        }


        /// <summary>
        /// Synchronize all the peers in the database. This is called by the ArenaPbxPeer agent
        /// to update the phon_peer table. This table links a physical phone device to a person's
        /// record in Arena.
        /// </summary>
        /// <param name="organizationId">The organization ID to use.</param>
        public void SyncPeers(int organizationId)
        {
            OdbcConnection odbc;
            OdbcDataReader rdr;
            OdbcCommand cmd;


            //
            // Load up all the extension rules for this request.
            //
            LookupCollection extensionRules = new LookupType(SystemLookupType.PhoneInternalExtensionRules).Values;

            //
            // Open an ODBC connection to the Asterisk MySQL database.
            //
            odbc = new OdbcConnection("DSN=Asterisk");
            odbc.Open();
            cmd = odbc.CreateCommand();

            //
            // Run a query to retrieve all the registered devices. We use realtime SIP peers so
            // we can query the database directly instead of connecting through AMI.
            //
            cmd.CommandText = "SELECT name,host,nat,ipaddr FROM sip";
            rdr = cmd.ExecuteReader();
            while (rdr.Read())
            {
                //
                // For each phone device found, save it to the database. The SavePeer() method
                // does the leg-work of matching to a person.
                //
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


        /// <summary>
        /// This method is used, I believe, to get the channel to call for the identified
        /// person. FollowMe is used to follow you around the office and ring the phone
        /// closest to you. We don't use follow me so pass back null.
        /// </summary>
        /// <param name="phoneType">Unknown parameter</param>
        /// <param name="phoneNumber">The phone number of the person to find.</param>
        /// <param name="personalChannel">The channel used to contact this person.</param>
        /// <param name="personalContext">The channel context used to contact this person.</param>
        public void GetFollowMeNumber(Guid phoneType, string phoneNumber, out string personalChannel, out string personalContext)
        {
            personalChannel = null;
            personalContext = null;
        }


        #endregion


        #region CDR Methods

        /// <summary>
        /// Retrieve all the CDR records that have not been loaded into the phone_cdr table
        /// yet. This method is called by the ArenaPbxCdr Agent.
        /// </summary>
        /// <returns>A collection of CDR records that are new since the last run.</returns>
        public CDRCollection GetCDRRecords()
        {
            CDRCollection cdrRecords = new CDRCollection();
            SqlDataReader rdr;


            //
            // Execute the stored procedure. The stored procedure merges the two tables
            // (the phone_cdr table in Arena and the cdr table in Asterisk) and returns
            // a reader with only the CDR records from Asterisk that do not exist in Arena.
            //
            rdr = new Arena.DataLayer.Organization.OrganizationData().ExecuteReader("cust_asterisk_sp_get_cdr_records");
            while (rdr.Read())
            {
                CDR cdr = new CDR();

                //
                // If the source channel is a SIP device (we do not yet use IAX) then
                // we need to strip out just the device name (extension number). Asterisk
                // provides this in a "SIP/268-293fab239" format.
                //
                string srcChannel = rdr["channel"].ToString();
                if (srcChannel.ToUpper().StartsWith("SIP/"))
                {
                    cdr.Source = srcChannel.Substring(4);
                    cdr.Source = cdr.Source.Substring(0, cdr.Source.IndexOf('-'));
                }
                else
                    cdr.Source = rdr["src"].ToString();

                //
                // If the destination channel is a SIP device (we do not yet use IAX) then
                // we need to strip out just the device name (extension number). Asterisk
                // provides this in a "SIP/268-293fab239" format.
                //
                string dstChannel = rdr["dstchannel"].ToString();
                if (dstChannel.ToUpper().StartsWith("SIP/"))
                {
                    cdr.Destination = dstChannel.Substring(4);
                    cdr.Destination = cdr.Destination.Substring(0, cdr.Destination.IndexOf('-'));
                }
                else
                    cdr.Destination = rdr["dst"].ToString();

                //
                // If the destination begins is 7 or more characters and does not begin with
                // a 9, then prepend the 9. Some of our phone calls have the 9, some do not.
                // Make sure they are all the same.
                // Next if it is a long distance call (e.g. 917605552732) strip out the 1 since
                // Arena does not use it.
                //
                if (cdr.Destination.Length >= 7 && cdr.Destination[0] != '9')
                    cdr.Destination = "9" + cdr.Destination; // Prepend a 9 for outward calls that don't have it.
                if (cdr.Destination.Length > 7 && cdr.Destination.Substring(0, 2) == "91")
                    cdr.Destination = "9" + cdr.Destination.Substring(2); // Strip out the 1 for long distance

                //
                // Get the CallerID as identified by Asterisk.
                //
                cdr.CallerID = rdr["clid"].ToString();

                //
                // Get the time the call began.
                //
                if (!rdr.IsDBNull(rdr.GetOrdinal("start")))
                    cdr.CallStart = (DateTime)rdr["start"];

                //
                // Get the time the call was answered (our system does not use this so the
                // stored procedure sets this to null).
                //
                if (!rdr.IsDBNull(rdr.GetOrdinal("answer")))
                    cdr.Answered = (DateTime)rdr["answer"];

                //
                // Get the time the call was ended.
                //
                if (!rdr.IsDBNull(rdr.GetOrdinal("end")))
                    cdr.CallEnd = (DateTime)rdr["end"];

                //
                // Get the duration of the call. As of Asterisk 1.6 the duration and billable
                // seconds is now a floating point, so it might return 129.4 seconds. Convert
                // to a whole number.
                //
                if (!rdr.IsDBNull(rdr.GetOrdinal("duration")))
                    cdr.Duration = Convert.ToInt32(rdr["duration"]);

                //
                // Get the billable duration of the call.
                //
                if (!rdr.IsDBNull(rdr.GetOrdinal("billsec")))
                    cdr.BillSeconds = Convert.ToInt32(rdr["billsec"]);

                //
                // The disposition is the "state" of the call.
                //
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

                //
                // Save the foreign key so that our stored procedure can find the
                // original CDR record later.
                //
                cdr.ForeignKey = rdr["uniqueid"].ToString();

                //
                // Add the CDR record to the collection. The agent worker will then match
                // the CDR record to the person records associated with the call.
                //
                cdrRecords.Add(cdr);
            }
            rdr.Close();

            return cdrRecords;
        }

        #endregion


        #region Voicemail methods

        /// <summary>
        /// Retrieve a list of voicemails for the identified person.
        /// </summary>
        /// <param name="person">The person whose voicemails we want to retrieve.</param>
        /// <returns>A List of Voicemail objects which identify the voicemail messages.</returns>
        public List<Voicemail> GetPersonVoicemails(Person person) { return null; }


        /// <summary>
        /// Delete the voicemail identified by it's unique ID number.
        /// </summary>
        /// <param name="VoiceMailID">ID of voicemail to delete.</param>
        public void DeleteVoicemail(int VoiceMailID) { }


        /// <summary>
        /// I think this retrieves a list of all voicemail messages in the entire
        /// PBX. But I am not sure.
        /// </summary>
        /// <returns>A List of Voicemail objects.</returns>
        public List<Voicemail> GetVoicemail() { return null; }


        /// <summary>
        /// Retrieve the voicemail by its unique ID number. Not sure why this is a GUID
        /// and DeleteVoicemail is an int.
        /// </summary>
        /// <param name="guid">The ID of the voicemail message to retrieve.</param>
        /// <returns>A new Voicemail object identified by the ID number.</returns>
        public Voicemail GetVoicemail(Guid guid) { return null; }


        /// <summary>
        /// Get the configuration (preferences) of voicemail for a user. Most VoIP PBX
        /// systems do not strongly tie voicemail boxes to a user internally. The objectName
        /// is most likely the voicemail box name.  Many systems use the phone extension for
        /// the mailbox name, but this is not a requirement.
        /// </summary>
        /// <param name="objectName">The name of the voicemail box.</param>
        /// <returns>A new VoicemailConfig which identifies the preferences for this voicemail box.</returns>
        public VoicemailConfig GetVoicemailConfiguration(string objectName) { return null; }


        /// <summary>
        /// Mark the specified voicemail message as processed. I am not entirely sure what
        /// processed means in this context. Perhaps it means "displayed to the user but
        /// not listened to yet."
        /// </summary>
        /// <param name="VoiceMailID">The ID number of the voicemail message.</param>
        public void MarkVoicemailProcessed(int VoiceMailID) { }


        /// <summary>
        /// Mark the specified voicemail messages as read. This means the user has
        /// listened to the message but has not yet deleted it.
        /// </summary>
        /// <param name="VoiceMailID">The ID number of the voicemail message.</param>
        public void MarkVoicemailRead(int VoiceMailID) { }


        /// <summary>
        /// Update the configuration (preferences) of the voicemail box. See the
        /// GetVoicemailConfiguration for a longer discussion.
        /// </summary>
        /// <param name="objectName">The name of the voicemail box.</param>
        /// <param name="voicemailConfig">The new configuration preferences to set.</param>
        public void SaveVoicemailConfiguration(string objectName, VoicemailConfig voicemailConfig) { }


        /// <summary>
        /// Check if the given voicemail message exists in the system. Because the PBX
        /// has multiple access points a message could be deleted by other means so this
        /// method is used to test if the voicemail still exists.
        /// </summary>
        /// <param name="VoiceMailID">The ID of the voicemail message.</param>
        /// <returns>true if the voicemail still exists or false if it does not exist anymore.</returns>
        public bool VoicemailExists(int VoiceMailID) { return false; }

        #endregion


        #region Private methods

        /// <summary>
        /// Save the information about a given peer. In a VoIP PBX system a peer is a physical
        /// device. A person may have multiple peers associated with him/her. For example I
        /// have a physical desk phone (first peer), a VoIP client on my iPhone (second peer).
        /// This method has been written on the assumption that I only care about my primary
        /// (desk phone) peer. We name our SIP peers after the extension, so my extension of
        /// 268 has a peer defined as "268".
        /// </summary>
        /// <param name="organizationId">The organization we are currently working in.</param>
        /// <param name="extensionRules">A collection of Lookups to use in matching this peer to a person.</param>
        /// <param name="objectName">The name of this peer object.</param>
        /// <param name="acl">Not a clue.</param>
        /// <param name="dynamic">If this is a dynamic (i.e. DHCP) peer.</param>
        /// <param name="natSupport">Does the peer support NAT?</param>
        /// <param name="ip">IP address of the peer.</param>
        /// <param name="type">The type of peer, e.g. SIP or IAX2.</param>
        private void SavePeer(int organizationId, LookupCollection extensionRules, string objectName, bool acl, bool dynamic, bool natSupport, string ip, string type)
        {
            string internalNumber = objectName;

            //
            // Match this peer to a extension and build internalNumber
            // to be the full phone number to reach this peer.
            //
            foreach (Lookup rule in extensionRules)
                if (Regex.Match(objectName, rule.Qualifier).Success)
                    if (rule.Qualifier3 != string.Empty)
                        internalNumber = rule.Qualifier3.Replace("##orig##", objectName);

            //
            // Find a person who has this exact phone number. If more than one person
            // is found, the first match is used.
            //
            PersonCollection peerPersons = new PersonCollection();
            peerPersons.LoadByPhone(internalNumber);
            if (peerPersons.Count > 0)
            {
                //
                // Save the new Phone Peer object, which associates a physical phone to a person.
                //
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
