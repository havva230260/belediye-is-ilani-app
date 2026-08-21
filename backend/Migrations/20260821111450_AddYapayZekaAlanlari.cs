using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace backend.Migrations
{
    /// <inheritdoc />
    public partial class AddYapayZekaAlanlari : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "CvMetni",
                table: "Basvurular",
                type: "text",
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<bool>(
                name: "KvkkOnayi",
                table: "Basvurular",
                type: "boolean",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<int>(
                name: "UygunlukPuani",
                table: "Basvurular",
                type: "integer",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "YapayZekaOzeti",
                table: "Basvurular",
                type: "text",
                nullable: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "CvMetni",
                table: "Basvurular");

            migrationBuilder.DropColumn(
                name: "KvkkOnayi",
                table: "Basvurular");

            migrationBuilder.DropColumn(
                name: "UygunlukPuani",
                table: "Basvurular");

            migrationBuilder.DropColumn(
                name: "YapayZekaOzeti",
                table: "Basvurular");
        }
    }
}
