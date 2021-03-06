/****** Qualified Trip  ******/
/***DO NOT RUN THIS PART, UNLESS APPLIED TO NEW DATABASE*****/
IF OBJECT_ID('SP_Ding.dbo.QualifiedTrip', 'U') IS NOT NULL 
  DROP TABLE SP_Ding.dbo.QualifiedTrip

SELECT  ROW_NUMBER() over(order by min(D.GpsTimeWsu) ,max(D.GpsTimeWsu)) as ID 
		,D.Device
		,D.Trip
		,(max(Time) - min(Time))/10 + 1 as dTime_X10
		,count(Time) as Num_Row
		,min(Time) as StartTime
		,min(D.GpsTimeWsu) as GpsStartTime
		,max(D.GpsTimeWsu) as GpsEndTime
		,min(LatitudeWsu) as La_MIN
		,max(LatitudeWsu) as La_MAX
		,min(LongitudeWsu) as Lo_MIN
		,max(LongitudeWsu) as Lo_MAX
		,max(GpsSpeedWsu) as V_MAX

  into  SP_Ding.dbo.QualifiedTrip
  FROM [SpFot].[dbo].[DataWsu] as D, SpFot.dbo.Summary as S
  Where S.Device = D.Device and S.Trip = D.Trip 
  group by D.Device, D.Trip
  Having count(Time) = (max(Time) - min(Time))/10 + 1   --No Time Miss
     and count(Time) > 10  -- The duration is more than 1 second
	 and min(D.LatitudeWsu) > 41.65 and max(D.LatitudeWsu)<44.5
	 and min(D.LongitudeWsu) > -86 and max(D.LongitudeWsu)<-82.37
  order by GpsStartTime,GpsEndTime


ALTER TABLE SP_Ding.dbo.QualifiedTrip ALTER COLUMN [ID] INTEGER NOT NULL
select top 1000 * from SP_Ding.dbo.QualifiedTrip
  

