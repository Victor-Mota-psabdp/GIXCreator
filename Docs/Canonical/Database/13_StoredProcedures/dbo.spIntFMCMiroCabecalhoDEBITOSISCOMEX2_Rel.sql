SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE Procedure [dbo].[spIntFMCMiroCabecalhoDEBITOSISCOMEX2_Rel] 
		@Num_PRoc	Varchar(16),
		@Tipo		Varchar(1),
		@id_evento	Varchar(1),
		@id_miro	int
--spIntFMCMiroCabecalhoDEBITOSISCOMEX_Rel 'IMFMT20090600601','3'
as	

if upper(@id_evento) <> 'K'
	begin
		SElect iSNULL(sum(iSNULL(vlr_item_custo,0)),0) Valor From Custo_Cliente CC 
			Join Fmc_Miro Miro on Miro.id_miro=cc.num_nf_custo

		Join Custo_Processo CPP on cc.num_proc=cpp.num_proc and cc.cd_tp_Tx=cpp.cd_tp_Tx	
			Join FMC_Plano_Contas_v2 PC on miro.id_evento=pc.id_evento and PC.cd_tp_tx=cc.cd_tp_Tx 
			Join Tipo_Taxa TT on TT.cd_tp_tx=cc.cd_tp_Tx
		where	
			cc.num_proc=@num_proc and tipo=@tipo and miro.id_miro=@id_miro
	end
ELSE if upper(@id_evento) = 'K'
	BEGIN
		SElect iSNULL(sum(iSNULL(vlr_item_custo,0)),0) Valor From Custo_Cliente CC 
			Join Fmc_Miro Miro on Miro.id_miro=cc.num_nf_custo
			Join FMC_Plano_Contas_v2 PC on miro.id_evento=pc.id_evento and PC.cd_tp_tx=cc.cd_tp_Tx 
			Join Tipo_Taxa TT on TT.cd_tp_tx=cc.cd_tp_Tx
		where	
			cc.num_proc=@num_proc and tipo=@tipo and miro.id_miro=@id_miro
			
			
	END

--SElect sum(vlr_item_custo) Valor From Custo_Cliente CC 
--	Join Fmc_Miro Miro on Miro.id_miro=cc.num_nf_custo

--Join Custo_Processo CPP on cc.num_proc=cpp.num_proc and cc.cd_tp_Tx=cpp.cd_tp_Tx	
--	Join FMC_Plano_Contas_v2 PC on miro.id_evento=pc.id_evento and PC.cd_tp_tx=cc.cd_tp_Tx 
--	Join Tipo_Taxa TT on TT.cd_tp_tx=cc.cd_tp_Tx
--where	
--	cc.num_proc=@num_proc and tipo=@tipo and miro.id_miro=@id_miro
--	and nome_tp_tx not like 'AFRMM%'


GO
