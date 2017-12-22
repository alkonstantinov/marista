﻿using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Marista.Common.ViewModels
{
    public class ProductVM
    {
        public int ProductId { get; set; }

        [Required, MaxLength(100)]
        [Display(Name="Name")]
        public string Name { get; set; }

        [Required]
        [Display(Name = "Description")]
        public string Description { get; set; }

        [Required]
        [Display(Name = "Price")]
        public decimal Price { get; set; }

        [Display(Name = "Promotional price")]
        public Nullable<decimal> PromotionalPrice { get; set; }

        [Required]
        [Display(Name = "Vertical category")]
        public int VCategoryId { get; set; }

        public string VCategoryCategoryName { get; set; }

        [Required]
        [Display(Name = "Horizontal category")]
        public int HCategoryId { get; set; }

        public string HCategoryCategoryName { get; set; }

        //required, enforced by the controller
        [Display(Name = "Picture")]
        public byte[] Picture { get; set; }
    }
}