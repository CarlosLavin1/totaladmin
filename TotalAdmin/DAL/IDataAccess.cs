using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TotalAdmin.Types;

namespace DAL
{
    public interface IDataAccess
    {
        /// <summary>
        /// Executes a database command synchronously and returns the result as a <see cref="DataTable"/>.
        /// </summary>
        /// <param name="cmdText">The text of the command to execute.</param>
        /// <param name="parms">Optional parameters for the command.</param>
        /// <param name="cmdType">The type of the command (stored procedure, text, etc.).</param>
        /// <returns>A <see cref="DataTable"/> containing the result of the command.</returns>
        DataTable Execute(string cmdText, List<Parm>? parms = null, CommandType cmdType = CommandType.StoredProcedure);
        /// <summary>
        /// Executes a database command asynchronously and returns the result as a <see cref="DataTable"/>.
        /// </summary>
        /// <param name="cmdText">The text of the command to execute.</param>
        /// <param name="parms">Optional parameters for the command.</param>
        /// <param name="cmdType">The type of the command (stored procedure, text, etc.).</param>
        /// <returns>A task representing the asynchronous operation. The task result contains 
        /// a <see cref="DataTable"/> containing the result of the command.</returns>
        Task<DataTable> ExecuteAsync(string cmdText, List<Parm>? parms = null, CommandType cmdType = CommandType.StoredProcedure);
        /// <summary>
        /// Executes a database command synchronously and returns the first column of the first row as an object.
        /// </summary>
        /// <param name="cmdText">The text of the command to execute.</param>
        /// <param name="parms">Optional parameters for the command.</param>
        /// <param name="cmdType">The type of the command (stored procedure, text, etc.).</param>
        /// <returns>The first column of the first row as an object.</returns>
        object ExecuteScalar(string cmdText, List<Parm>? parms = null, CommandType cmdType = CommandType.StoredProcedure);
        /// <summary>
        /// Executes a database command asynchronously and returns the first column of the first row as an object.
        /// </summary>
        /// <param name="cmdText">The text of the command to execute.</param>
        /// <param name="parms">Optional parameters for the command.</param>
        /// <param name="cmdType">The type of the command (stored procedure, text, etc.).</param>
        /// <returns>A task representing the asynchronous operation. The task result contains the first column of the first row as an object.</returns>
        Task<object?> ExecuteScalarAsync(string cmdText, List<Parm>? parms = null, CommandType cmdType = CommandType.StoredProcedure);
        /// <summary>
        /// Executes a database command synchronously and returns the number of rows affected.
        /// </summary>
        /// <param name="cmdText">The text of the command to execute.</param>
        /// <param name="parms">Optional parameters for the command.</param>
        /// <param name="cmdType">The type of the command (stored procedure, text, etc.).</param>
        /// <returns>The number of rows affected.</returns>
        int ExecuteNonQuery(string cmdText, List<Parm>? parms = null, CommandType cmdType = CommandType.StoredProcedure);
        /// <summary>
        /// Executes a database command asynchronously and returns the number of rows affected.
        /// </summary>
        /// <param name="cmdText">The text of the command to execute.</param>
        /// <param name="parms">Optional parameters for the command.</param>
        /// <param name="cmdType">The type of the command (stored procedure, text, etc.).</param>
        /// <returns>A task representing the asynchronous operation. The task result contains the 
        /// number of rows affected.</returns>
        Task<int> ExecuteNonQueryAsync(string cmdText, List<Parm>? parms = null, CommandType cmdType = CommandType.StoredProcedure);
    }
}
