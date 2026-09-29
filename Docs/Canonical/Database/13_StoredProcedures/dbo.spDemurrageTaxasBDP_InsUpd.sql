SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spDemurrageTaxasBDP_InsUpd]

			@Nome_Tp_Cont 		varchar(50),
			@DS_Periodo			varchar(50),
			@dias				int,
			@valor				decimal(12,2)
			
AS
Begin Transaction

Declare @cd_tp_cont as varchar(3)
set @cd_tp_cont = (select cd_tp_cont from Tipo_container where Nome_Tp_Cont = @Nome_Tp_Cont)
Declare @periodo as int
set @periodo = (select cd_periodo from Tipo_Periodo_Demurrage where ds_periodo = @DS_Periodo)


	If  exists (select cd_tp_cont from Taxa_Demurrage_BDP where cd_tp_cont=@cd_tp_cont and Periodo=@periodo)
	   Begin
		Update
			Taxa_Demurrage_BDP
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
				Taxa_Demurrage_BDP
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
