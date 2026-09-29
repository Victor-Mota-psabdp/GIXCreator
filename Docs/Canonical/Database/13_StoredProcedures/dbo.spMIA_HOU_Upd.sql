SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spMIA_HOU_Upd] --'IMSSZ200906022', 'IMWAL20090102501'
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
		--Tabela House_Imp_Aer
			Update
				House_Imp_Aer
			Set
				Num_Proc_MIA = 'JOB'
			Where
				Num_Proc_HIA = @Job
		End
	ELSE
		Begin
		--Tabela House_Imp_Aer
			Update
				House_Imp_Aer
			Set
				Num_Proc_MIA = @Master,
				Cd_Org_HIA	 =(select Cd_Org_MIA from Master_Imp_Aer where Num_Proc_MIA=@Master),
				Cd_Dst_HIA	 =(select Cd_Dst_MIA from Master_Imp_Aer where Num_Proc_MIA=@Master),
				Voo_HIA		 =(select Voo_MIA from Master_Imp_Aer where Num_Proc_MIA=@Master),
				--#100-68342 - Incluido
				MAWB_HIA = (select MAWB_HIA from Master_Imp_Aer where Num_Proc_MIA= @Master)
			Where
				Num_Proc_HIA = @Job

		--Tabela select * from Job_Imp_Aer select * from Master_Imp_Aer select * from house_Imp_Aer
			Update
				Job_Imp_Aer
			Set
				Cd_Cia_Aer	 =(select Cd_Cia_Aer from Master_Imp_Aer where Num_Proc_MIA=@Master)
			Where
				Num_Proc_HIA = @Job

		--Tabela LLP_Imp_Aer
			Update
				LLP_Imp_Aer
			Set
				ETD_LIA = (select ETD_Master from LLP_Master where Num_Proc_Master=@Master),
				ATD_LIA = (select ATD_Master from LLP_Master where Num_Proc_Master=@Master),
				ETA_LIA = (select ETA_Master from LLP_Master where Num_Proc_Master=@Master),
				ATA_LIA = (select ATA_Master from LLP_Master where Num_Proc_Master=@Master)
				--Incluso 04-09-2012 - Status do Processo
				--Excluido 21/10/2022 - Cadu 100-338956
				--,ID_Status = (Select ID_Status from LLP_Master where Num_Proc_Master = @Master)

			Where
				Num_Proc_LIA = @Job

		--Tabela Cta_Cte_hou_imp_XXX
			--exec spFreteAuto_Ins @Master , @Job

		End

	IF @@Error <> 0
		BEGIN
			ROLLBACK TRANSACTION
			RETURN -1
		END

Commit Transaction 


GO
