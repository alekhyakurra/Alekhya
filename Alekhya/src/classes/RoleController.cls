public class RoleController {
      public List<Role__c> roles{get;set;}
      public Role__c role{get;set;}
      public list<FindChild> childRoleNode;

      public RoleController() {
          roles=[select Role__c.ID,Role__c.Name, Role__c.Description__c,Role__c.Role_Reports_To__c from Role__c where Role__c.Role_Reports_To__c=null order by CreatedDate];
          if(roles.size()>0){
             role=roles[0];
          }
      }

     //Inner Class to find child Roles
      public class FindChild{
         public Role__c boss{get;set;}
         public list<Role__c> reportees{get;set;}
         public FindChild(Role__c parentRole,list<Role__c> reporteeRoles){
             this.boss=parentRole;
             this.reportees=reporteeRoles;
         }
      }

      public list<FindChild> getmainroles(){
         childRoleNode = new List<FindChild>();
         List<Role__c> tempBoss = [Select Id,Name from Role__c where Role__c.Role_Reports_To__c!=null order by CreatedDate];

         for (Integer i =0; i< tempBoss.size() ; i++)
         {
             List<Role__c> tempReportee = [Select Id,Name from Role__c where Role_Reports_To__c = :tempBoss[i].Id];
             childRoleNode.add(new FindChild(tempBoss[i],tempReportee));
         } 
         return childRoleNode;
      }
   }