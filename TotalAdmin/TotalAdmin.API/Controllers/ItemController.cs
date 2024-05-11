using Microsoft.AspNetCore.Mvc;
using TotalAdmin.Model.DTO;
using TotalAdmin.Model.Entities;
using TotalAdmin.Service;

namespace TotalAdmin.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ItemController : Controller
    {
        private readonly ItemService service = new();

        // POST: api/Item
        [HttpPost]
        [ProducesResponseType(StatusCodes.Status201Created)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public async Task<ActionResult<Item>> Create([FromBody] Item item)
        {
            try
            {
                item = await service.AddItem(item);
                if (item.Errors.Count != 0)
                    return BadRequest(item);
            }
            catch (Exception)
            {
                return Problem(title: "An internal error has occurred. Please contact the system administrator");
            }

            return Ok(item);
        }

        [HttpPatch("{itemId}/{newItemStatus}/{reason}")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<IActionResult> UpdateItem(int itemId, int newItemStatus, string? reason)
        {
            try
            {
                bool isUpdated = await service.UpdateItem(itemId, newItemStatus, reason);
                if (isUpdated)
                {
                    return Ok(new { message = "Item updated successfully" });
                }
                else
                {
                    return NotFound(new { message = "Item not found" });
                }
            }
            catch (Exception)
            {
                return Problem(title: "An internal error has occurred. Please contact the system administrator");
            }
        }

    }

}
