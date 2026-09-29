SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE Procedure [dbo].[spATL_AjusteDataPrevisao_EnvioPrestacaodeContas_Upd]--'34783','A','2013-04-30'
	--@JOB		varchar(16),
	@NF				varchar(8),
	@RefAcessoNF	char(1),
	@DataPrevisao	datetime
		
as
Begin Transaction
		set @DataPrevisao = @DataPrevisao + 30

--HOUSE
--	If len(@JOB) = 16
--	Begin
--		If left(@JOB,2) = 'EA'
--		Begin
			update Cta_Cte_Hou_Exp_Aer set Dt_Prev_Pgto_HEA = CONVERT(varchar(10),@DataPrevisao,103)
			where Ref_Acesso_NF_HEA = @RefAcessoNF AND  Num_NF_HEA = @NF
--		End
--		If left(@JOB,2) = 'EM'
--		Begin
			update Cta_Cte_Hou_Exp_Mar set Dt_Prev_Pgto_HEM = CONVERT(varchar(10),@DataPrevisao,103)
			where Num_NF_HEM = @NF and Ref_Acesso_NF_HEM = @RefAcessoNF --AND Num_Proc_HEM = @JOB 
--		End
--		If left(@JOB,2) = 'EO'
--		Begin
			update Cta_Cte_Hou_Exp_OUT set Dt_Prev_Pgto_HEO = CONVERT(varchar(10),@DataPrevisao,103)
			where Num_NF_HEO = @NF and Ref_Acesso_NF_HEO = @RefAcessoNF --Num_Proc_HEO = @JOB
--		End		
--		If left(@JOB,2) = 'IA'
--		Begin
			update Cta_Cte_Hou_IMP_Aer set Dt_Prev_Pgto_HIA = CONVERT(varchar(10),@DataPrevisao,103)
			where Num_NF_HIA = @NF and Ref_Acesso_NF_HIA = @RefAcessoNF--Num_Proc_HIA = @JOB 
--		End
--		If left(@JOB,2) = 'IM'
--		Begin
			update Cta_Cte_Hou_IMP_Mar set Dt_Prev_Pgto_HIM = CONVERT(varchar(10),@DataPrevisao,103)
			where Num_NF_HIM = @NF and Ref_Acesso_NF_HIM = @RefAcessoNF --Num_Proc_HIM = @JOB
--		End
--		If left(@JOB,2) = 'IO'
--		Begin
			update Cta_Cte_Hou_IMP_OUT set Dt_Prev_Pgto_HIO = CONVERT(varchar(10),@DataPrevisao,103)
			where Num_NF_HIO = @NF and Ref_Acesso_NF_HIO = @RefAcessoNF --Num_Proc_HIO = @JOB 
--		End		
--	End
	
--MASTER
--	If len(@JOB) = 14
--	Begin
--		If left(@JOB,2) = 'EA'
--		Begin
			update Cta_Cte_MAS_Exp_Aer set Dt_Prev_Pgto_MEA = CONVERT(varchar(10),@DataPrevisao,103)
			where Num_NF_MEA = @NF and Ref_Acesso_NF_MEA = @RefAcessoNF --Num_Proc_MEA = @JOB and
--		End
--		If left(@JOB,2) = 'EM'
--		Begin
			update Cta_Cte_MAS_Exp_Mar set Dt_Prev_Pgto_MEM = CONVERT(varchar(10),@DataPrevisao,103)
			where  Num_NF_MEM = @NF and Ref_Acesso_NF_MEM = @RefAcessoNF --Num_Proc_MEM = @JOB 
--		End
--		If left(@JOB,2) = 'IA'
--		Begin
			update Cta_Cte_MAS_IMP_Aer set Dt_Prev_Pgto_MIA = CONVERT(varchar(10),@DataPrevisao,103)
			where Num_NF_MIA = @NF and Ref_Acesso_NF_MIA = @RefAcessoNF --Num_Proc_MIA = @JOB 
--		End
--		If left(@JOB,2) = 'IM'
--		Begin
			update Cta_Cte_MAS_IMP_Mar set Dt_Prev_Pgto_MIM = CONVERT(varchar(10),@DataPrevisao,103)
			where Num_NF_MIM = @NF and Ref_Acesso_NF_MIM = @RefAcessoNF --Num_Proc_MIM = @JOB and 
--		End
--	End
	IF @@ERROR <> 0
		BEGIN
			RETURN -1
		END
COMMIT TRANSACTION
GO
