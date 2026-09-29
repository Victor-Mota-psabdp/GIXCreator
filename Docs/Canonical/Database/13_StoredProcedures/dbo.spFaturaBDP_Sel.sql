SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[spFaturaBDP_Sel] --'IMCSR20090522301','DOW BRASIL S 0962326'
(
@Processo	varchar(16),
@Pessoa		varchar(50)
)


AS

	Declare @Cd_Pes as varchar(10)

	set @cd_pes = (Select cd_pes from pessoa where apelido = @Pessoa)

	SELECT distinct TM.Nome_tp_moeda Moeda, CC.DC_hem DC, dbo.VerParidade(convert(varchar(10),getdate(),103),CC.cd_tp_moeda,'IMM') Paridade,TT.Nome_tp_tx,vlr_org_HEM Valor FROM Cta_Cte_Hou_Exp_Mar CC
		join tipo_moeda TM on CC.cd_tp_moeda = TM.cd_tp_moeda
		left Join Tipo_Taxa TT on CC.cd_tp_tx = TT.cd_tp_tx
		Join House_Exp_Mar HOU on HOU.num_proc_HEM = CC.num_proc_HEM --and HOU.cd_export_hem = cc.cd_cred_dev_hem
		Left join Caixa_Hou_Exp_Mar CXA on	CC.num_proc_HEM	= CXA.num_proc_HEM and CC.cd_tp_tx = CXA.cd_tp_tx and CC.dc_HEM = CXA.dc_HEM
		Left Join Item_Fat FAT on CC.num_proc_HEM = FAT.Num_proc and CC.cd_tp_tx = FAT.cd_tp_tx
		join Fatura FT on FAT.FatCod = FT.FatCod --and (FatStatus <> 1 or FatStatus is null)
	WHERE CXA.Num_Lcto is null and CC.Num_Proc_HEM = @Processo  and cc.cd_cred_dev_hem = @cd_pes and (FatStatus <> 1 or FatStatus is null)
	
union all

	SELECT distinct TM.Nome_tp_Moeda, CC.DC_hea, dbo.VerParidade(convert(varchar(10),getdate(),103),CC.cd_tp_moeda,'IMM') Paridade,TT.Nome_tp_tx,vlr_org_HEA Valor FROM Cta_Cte_Hou_Exp_Aer CC
		join tipo_moeda TM on CC.cd_tp_moeda = TM.cd_tp_moeda
		left Join Tipo_Taxa TT	on CC.cd_tp_tx = TT.cd_tp_tx
		Join House_Exp_Aer HOU on HOU.num_proc_HEA = CC.num_proc_HEA --and HOU.cd_export_hea = cc.cd_cred_dev_hea
		Left join Caixa_Hou_Exp_Aer CXA on	CC.num_proc_HEA	= CXA.num_proc_HEA and CC.cd_tp_tx = CXA.cd_tp_tx and CC.dc_HEA = CXA.dc_HEA
		Left Join Item_Fat FAT on CC.num_proc_HEA = FAT.Num_proc and CC.cd_tp_tx = FAT.cd_tp_tx
		join Fatura FT on FAT.FatCod = FT.FatCod --and (FatStatus <> 0 or FatStatus is null)
	WHERE CXA.Num_Lcto is null  and CC.Num_Proc_HEA = @Processo and cc.cd_cred_dev_hea = @cd_pes and (FatStatus <> 1 or FatStatus is null)

union all

	SELECT distinct TM.Nome_tp_Moeda, CC.DC_heo, dbo.VerParidade(convert(varchar(10),getdate(),103),CC.cd_tp_moeda,'IMM') Paridade,TT.Nome_tp_tx,vlr_org_HEO Valor FROM Cta_Cte_Hou_Exp_Out CC
		join tipo_moeda TM on CC.cd_tp_moeda = TM.cd_tp_moeda
		left Join Tipo_Taxa TT	on CC.cd_tp_tx = TT.cd_tp_tx
		Join House_Exp_Out HOU on HOU.num_proc_HEO = CC.num_proc_HEO --and HOU.cd_export_heo = cc.cd_cred_dev_heo
		Left join Caixa_Hou_Exp_Out CXA on	CC.num_proc_HEO	= CXA.num_proc_HEO and CC.cd_tp_tx = CXA.cd_tp_tx and CC.dc_HEO = CXA.dc_HEO
		Left Join Item_Fat FAT on CC.num_proc_HEO = FAT.Num_proc and CC.cd_tp_tx = FAT.cd_tp_tx
		join Fatura FT on FAT.FatCod = FT.FatCod 
	WHERE CXA.Num_Lcto is null and CC.Num_Proc_HEO = @Processo  and cc.cd_cred_dev_heo = @cd_pes and (FatStatus <> 1 or FatStatus is null)

union all

	SELECT distinct TM.Nome_tp_Moeda, CC.DC_him, dbo.VerParidade(convert(varchar(10),getdate(),103),CC.cd_tp_moeda,'IMM') Paridade,TT.Nome_tp_tx,vlr_org_HIM Valor FROM Cta_Cte_Hou_Imp_Mar CC
		join tipo_moeda TM on CC.cd_tp_moeda = TM.cd_tp_moeda
		left Join Tipo_Taxa TT	on CC.cd_tp_tx = TT.cd_tp_tx
		Join House_Imp_Mar HOU on HOU.num_proc_HIM = CC.num_proc_HIM --and HOU.cd_consig_him = cc.cd_cred_dev_him
		Left join Caixa_Hou_Imp_Mar CXA on	CC.num_proc_HIM	= CXA.num_proc_HIM and CC.cd_tp_tx = CXA.cd_tp_tx and CC.dc_HIM = CXA.dc_HIM
		Left Join Item_Fat FAT on CC.Num_proc_him = FAT.Num_proc and CC.cd_tp_tx = FAT.cd_tp_Tx
		left join Fatura FT on FAT.FatCod = FT.FatCod
	WHERE  CXA.Num_Lcto is null and CC.Num_Proc_HIM = @Processo  and cc.cd_cred_dev_him = @cd_pes and (FatStatus <> 1 or FatStatus is null)

union all

	SELECT distinct TM.Nome_tp_Moeda, CC.DC_hia, dbo.VerParidade(convert(varchar(10),getdate(),103),CC.cd_tp_moeda,'IMM') Paridade,TT.Nome_tp_tx,vlr_org_HIA Valor FROM Cta_Cte_Hou_Imp_Aer CC
		join tipo_moeda TM on CC.cd_tp_moeda = TM.cd_tp_moeda
		left Join Tipo_Taxa TT	on CC.cd_tp_tx = TT.cd_tp_tx
		Join House_Imp_Aer HOU on HOU.num_proc_HIA = CC.num_proc_HIA --and HOU.cd_consig_hia = cc.cd_cred_dev_hia
		Left join Caixa_Hou_Imp_Aer CXA on	CC.num_proc_HIA	= CXA.num_proc_HIA and CC.cd_tp_tx = CXA.cd_tp_tx and CC.dc_HIA = CXA.dc_HIA
		Left Join Item_Fat FAT on CC.num_proc_HIA = FAT.Num_proc and CC.cd_tp_tx = FAT.cd_tp_tx
		join Fatura FT on FAT.FatCod = FT.FatCod --and (FatStatus <> 0 or FatStatus is null)
	WHERE CXA.Num_Lcto is null and CC.Num_Proc_HIA = @Processo and cc.cd_cred_dev_hia = @cd_pes and (FatStatus <> 1 or FatStatus is null)

union all

	SELECT distinct TM.Nome_tp_Moeda, CC.DC_hio, dbo.VerParidade(convert(varchar(10),getdate(),103),CC.cd_tp_moeda,'IMM') Paridade,TT.Nome_tp_tx,vlr_org_HIO Valor FROM Cta_Cte_Hou_Imp_Out CC
		join tipo_moeda TM on CC.cd_tp_moeda = TM.cd_tp_moeda
		left Join Tipo_Taxa TT	on CC.cd_tp_tx = TT.cd_tp_tx
		Join House_Imp_Out HOU on HOU.num_proc_HIO = CC.num_proc_HIO --and HOU.cd_consig_hio = cc.cd_cred_dev_hio
		Left join Caixa_Hou_Imp_Out CXA on	CC.num_proc_HIO	= CXA.num_proc_HIO and CC.cd_tp_tx = CXA.cd_tp_tx and CC.dc_HIO = CXA.dc_HIO
		Left Join Item_Fat FAT on CC.num_proc_HIO = FAT.Num_proc and CC.cd_tp_tx = FAT.cd_tp_tx
		join Fatura FT on FAT.FatCod = FT.FatCod --and (FatStatus <> 0 or FatStatus is null)
	WHERE CXA.Num_Lcto is null and CC.Num_Proc_HIO = @Processo and cc.cd_cred_dev_hio = @cd_pes and (FatStatus <> 1 or FatStatus is null)













GO
