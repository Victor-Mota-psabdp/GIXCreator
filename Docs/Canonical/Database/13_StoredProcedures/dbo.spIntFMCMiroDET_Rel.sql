SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






create Procedure [dbo].[spIntFMCMiroDET_Rel]-- 'IMFMT20090600601','3',213
		@Num_PRoc	Varchar(16),
		@Tipo		Varchar(1),
		@id_miro	int

as
	
select Cast(nome_tp_tx as Char(30)) + ' = R$ ' +  cast(SUM(vlr_item_custo) as varchar(30)) Saida from custo_cliente CC
Join Fmc_Miro Miro on Miro.id_miro=cc.num_nf_custo
Join House_imp_aer hou on hou.num_proc_hia=cc.num_proc
--Join IntFMC_Plano_Contas PC on miro.id_evento=pc.id_evento and PC.cd_tp_tx=cc.cd_tp_Tx and cd_pes=cd_Export_hia
Join FMC_Plano_Contas_V2 PC on miro.id_evento=pc.id_evento and PC.cd_tp_tx=cc.cd_tp_Tx 
Join Tipo_Taxa TT on TT.cd_tp_tx=cc.cd_tp_Tx
where
	num_proc=@num_proc and tipo=@tipo and miro.id_miro=@Id_miro
GROUP BY 
	nome_tp_tx


UNION


select Cast(nome_tp_tx as Char(30)) + ' = R$ ' +  cast(SUM(vlr_item_custo) as varchar(30)) Saida from custo_cliente CC
Join Fmc_Miro Miro on Miro.id_miro=cc.num_nf_custo
Join House_imp_mAR hou on hou.num_proc_hiM=cc.num_proc
--Join IntFMC_Plano_Contas PC on miro.id_evento = pc.id_evento and PC.cd_tp_tx=cc.cd_tp_Tx and cd_pes=cd_Export_hiM
Join FMC_Plano_Contas_V2 PC on miro.id_evento=pc.id_evento and PC.cd_tp_tx=cc.cd_tp_Tx 
Join Tipo_Taxa TT on TT.cd_tp_tx=cc.cd_tp_Tx
where
	num_proc=@num_proc and tipo=@tipo and miro.id_miro=@Id_miro
GROUP BY 
nome_tp_tx






GO
