SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spDemurrageTaxas_InsUpd]

			@cd_tp_cont 		varchar(3),
			@periodo			int,
			@dias				int,
			@valor				decimal(12,2)
			
AS

Begin Transaction
	If  exists (select cd_tp_cont from Taxa_Demurrage where cd_tp_cont=@cd_tp_cont and Periodo=@periodo)
	   Begin
		Update
			Taxa_Demurrage
		Set			
			dias = @dias,
			taxa = @valor	
		Where
			cd_tp_cont=@cd_tp_cont and 
			Periodo=@periodo
	   End
	Else
		Begin
			Insert
				Taxa_Demurrage
			(
				cd_tp_cont,
				periodo,
				dias,
				taxa				
			)
			Values
			(
				@cd_tp_cont,
				@periodo,
				@dias,
				@valor				
			)

			If @@Error  <> 0 
				Begin 
					Rollback  Transaction 
					Return -1 
				End 
			Else
				Begin 
					Commit Transaction 
					Return 1 
				End 
		End
			
commit Transaction













GO
