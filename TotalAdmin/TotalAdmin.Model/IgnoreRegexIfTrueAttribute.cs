using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using TotalAdmin.Model;

namespace TotalAdmin.Model
{
    public class IgnoreRegexIfTrueAttribute : ValidationAttribute
    {
        private readonly bool _ignoreIf;

        public IgnoreRegexIfTrueAttribute(bool ignoreIf)
        {
            _ignoreIf = ignoreIf;
        }

        protected override ValidationResult IsValid(object value, ValidationContext validationContext)
        {
            var hashedPassword = value as string;
            var instance = validationContext.ObjectInstance as Employee;

            if (instance != null && _ignoreIf)
            {
                return ValidationResult.Success;
            }

            // Otherwise, perform the regular expression validation
            var regex = new Regex("^(?=.*[A-Z])(?=.*\\d)(?=.*[!@#$%^&*()_+{}\\[\\]:;<>,.?\\/\\\\|-]).{6,}$");
            if (!regex.IsMatch(hashedPassword))
            {
                return new ValidationResult("Password must have 1 uppercase letter, 1 number, and 1 special character");
            }

            return ValidationResult.Success;
        }
    }
}
