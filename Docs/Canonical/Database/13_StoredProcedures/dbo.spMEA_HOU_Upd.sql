SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[spMEA_HOU_Upd] --'IMSSZ200906022', 'IMWAL20090102501'
	@Master		VarChar(14),
	@Job		varchar(16)
AS

Begin Transaction

		--IF EXISTS(select id_AX from vwAXDocs where NumeroInternoAX = @Master)
		--	BEGIN
		--		RETURN -2
		--	END
	If UPPER(@Master) = 'JOB'
		Begin
		--Tabela House_Exp_Aer
			Update
				House_Exp_Aer
			Set
				Num_Proc_MEA = 'JOB'
			Where
				Num_Proc_HEA = @Job
		End
	ELSE
		Begin
		--Tabela House_Exp_Aer
			Update
				House_Exp_Aer
			Set
				Num_Proc_MEA = @Master,
				Cd_Org_HEA	 =(select Cd_Org_MEA from Master_Exp_Aer where Num_Proc_MEA=@Master),
				--Cd_Dst_HEA	 =(select Cd_Dst_MEA from Master_Exp_Aer where Num_Proc_MEA=@Master),
				Voo_HEA		 =(select Voo_MEA from Master_Exp_Aer where Num_Proc_MEA=@Master),
				MAWB_HEA	 =(select MAWB_MEA from Master_Exp_Aer where Num_Proc_MEA=@Master)
			Where
				Num_Proc_HEA = @Job

		--Tabela LLP_Exp_Aer
			Update
				LLP_Exp_Aer
			Set
				ETD_LEA = (select ETD_Master from LLP_Master where Num_Proc_Master=@Master),
				ATD_LEA = (select ATD_Master from LLP_Master where Num_Proc_Master=@Master),
				ETA_LEA = (select ETA_Master from LLP_Master where Num_Proc_Master=@Master),
				ATA_LEA = (select ATA_Master from LLP_Master where Num_Proc_Master=@Master),
				Cd_CiaAerea_Lea = (select Cd_Cia_Aer from Master_Exp_Aer where Num_Proc_MEA=@Master)
				--Incluso 04-09-2012 - Status do Processo
				--Excluido 21/10/2022 - Cadu 100-338956
				--,ID_Status = (Select ID_Status from LLP_Master where Num_Proc_Master = @Master)
			Where
				Num_Proc_LEA = @Job
		End

	IF @@Error <> 0
		BEGIN
			ROLLBACK TRANSACTION
			RETURN -1
		END

Commit Transaction 
















































GO
