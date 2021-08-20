namespace CodeCooker.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class init1 : DbMigration
    {
        public override void Up()
        {
            MoveTable(name: "CodeCooker.UserProfile", newSchema: "dbo");
        }
        
        public override void Down()
        {
            MoveTable(name: "dbo.UserProfile", newSchema: "CodeCooker");
        }
    }
}
