/**
Handles mixed dml situations in code. It runs the DML operation in different context for Test code only, so that conflict between DML on setup and non-setup object is gone.

PLEASE NOTE:
============
methods are not named as delete, insert because they are reserved words by Apex
*/
public without sharing class MixedDMLOps {
	
  private static List<sObject>sObjects
  {
  	get
  	{
  		if(sObjects == null )
  		{
  			sObjects = new List<sObject>();
  		}
  		return sObjects;
  	} 
  	set;
  }
  
  
  
  public static void add(sObject aSObject)
  {
  	sObjects.add(aSObject);
  }
  public static void add(sObject[] sObjectList)
  {
  	sObjects.addAll(sObjectList);
  }
  
  
  // DML UPDATE operation 
  public static Database.Saveresult[] up (Sobject[] objs) {

    Database.Saveresult[] updateRes;
     if (Test.isRunningTest()) {
          System.runAs(new User(Id = Userinfo.getUserId())) {
          updateRes = database.update(objs);
          }
        } else {
        updateRes = database.update(objs);
        }  
    return updateRes;
  }
  
  public static Database.Saveresult[] up ()
  {
  	Database.Saveresult[] result = up(sObjects);
  	sObjects = null;
  	return result;
  }
  
  public static void ups(Sobject[] objs)
  {
  	List<sObject>updateRecords = new List<sObject>();
  	List<sObject>insertRecords = new List<sObject>();
  	for(sObject o : objs)
  	{
  		if( o.get('id') == null)
  		{
  			insertRecords.add(o);
  		}
  		else
  		{
  			updateRecords.add(o);
  		}
  		
  		
  	}
  	up(updateRecords);
  	ins(insertRecords);
  }
  
  public static void ups()
  {
  	ups(sObjects);
  	sObjects = null;
  }
  
   
  // DML DELETE
  public static Database.DeleteResult[] del (Sobject[] objs) {
    Database.DeleteResult[] delRes;
     if (Test.isRunningTest()) {
          System.runAs(new User(Id = Userinfo.getUserId())) {
          delRes = database.delete(objs);
          }
        } else {
        delRes = database.delete(objs);
        }  
    return delRes;
  }
  
  public static Database.DeleteResult[] del ()
  {
  	Database.DeleteResult[] result = del(sObjects);
  	sObjects = null;
  	return result;
  }
   
   
  // DML INSERT
  public static Database.Saveresult[] ins (Sobject[] objs) {
    Database.Saveresult[] res;
     if (Test.isRunningTest()) {
          System.runAs(new User(Id = Userinfo.getUserId())) {
          res = database.insert(objs);
          }
        } else {
        res = database.insert(objs);
        }  
    return res;
  }
  
  public static Database.SaveResult[] ins ()
  {
  	Database.SaveResult[] result = ins(sObjects);
  	sObjects = null;
  	return result;
  }
   
   
}