namespace CodeCooker.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class init : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "dbo.Theme",
                c => new
                    {
                        ThemeID = c.Int(nullable: false, identity: true),
                        Name = c.String(),
                    })
                .PrimaryKey(t => t.ThemeID);
            
            CreateTable(
                "CodeCooker.UserProfile",
                c => new
                    {
                        UserId = c.Int(nullable: false, identity: true),
                        UserName = c.String(),
                        ThemeID = c.Int(),
                    })
                .PrimaryKey(t => t.UserId)
                .ForeignKey("dbo.Theme", t => t.ThemeID)
                .Index(t => t.ThemeID);
            
        }
        
        public override void Down()
        {
            DropForeignKey("CodeCooker.UserProfile", "ThemeID", "dbo.Theme");
            DropIndex("CodeCooker.UserProfile", new[] { "ThemeID" });
            DropTable("CodeCooker.UserProfile");
            DropTable("dbo.Theme");
        }
    }
}
