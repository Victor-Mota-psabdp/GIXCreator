SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--select * from ATL_INT.dbo.Parametro_Leitura_FComex
CREATE Procedure [dbo].[spATL_Parametro_Leitura_FComex_InsUpd]
AS
	--declare @CreatedOrModifiedStart varchar(25),
	--        @CreatedOrModifiedEnd varchar(25)

Begin Transaction
		begin 
		DECLARE @DATEADDMinutes as Datetime, @Getdate as Datetime
		set @DATEADDMinutes = (select DATEADD(MINUTE,-20,getdate()))
		set @Getdate = (select DATEADD(MINUTE,20,getdate()))
		--set @CreatedOrModifiedStart =  FORMAT (getdate()-120, 'MM/dd/yyyy hh:mm:ss') 
		--set @CreatedOrModifiedStart =  FORMAT (@DATEADDMinutes, 'MM/dd/yyyy hh:mm:ss') 
		--set @CreatedOrModifiedEnd =  FORMAT (getdate(), 'MM/dd/yyyy hh:mm:ss')
		Begin
			If  (select COUNT(*) as total from ATL_INT.dbo.Parametro_Leitura_FComex) > 0
	 				Begin
			  			Update
						ATL_INT.dbo.Parametro_Leitura_FComex set 
						CreatedOrModifiedStart = @DATEADDMinutes, --@CreatedOrModifiedStart,
						CreatedOrModifiedEnd =@Getdate --@CreatedOrModifiedEnd  
					end 
			else 
				begin
					insert into ATL_INT.dbo.Parametro_Leitura_FComex   
								(CreatedOrModifiedStart, 
								CreatedOrModifiedEnd) 
					values  
								(@DATEADDMinutes,@Getdate)
								--(@CreatedOrModifiedStart, 
								--@CreatedOrModifiedEnd)  
				end 
		End

	if @@error <> 0
		Begin

			RollBack Transaction
			return 0
		End

Commit Transaction
end 
GO
