//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace Marista.DL
{
    using System;
    using System.Collections.Generic;
    
    public partial class BP
    {
        public int BPId { get; set; }
        public string BPName { get; set; }
        public string EMail { get; set; }
        public string PayPal { get; set; }
        public string Address { get; set; }
        public int CountryId { get; set; }
        public int SiteUserId { get; set; }
        public byte[] Files { get; set; }
        public bool Active { get; set; }
        public string FileName { get; set; }
    
        public virtual Country Country { get; set; }
        public virtual SiteUser SiteUser { get; set; }
    }
}