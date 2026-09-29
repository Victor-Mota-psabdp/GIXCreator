SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spConsolidadaCapa_REL]-- 'IAVCP201102009'
	@Num_Proc_Master	Varchar(14)
as
--IMPORT
	IF left(@Num_Proc_Master,2)='IM'
		select LM.Num_Proc_Master Num_Proc_Master, 
		LM.ETD_Master ETD, ARM.nome_armador Armador, Orig.Nome_local Origem, Dest.Nome_local Destino,
		AGT.nome_raz_soc Agente,MAS.Navio_MIM Navio, Viagem_MIM Viagem, LM.ETA_Master ETA,hou.hawb_him HAWB, MAS.mawb_mim MAWB,num_proC_him Job,CS.Nome_Raz_Soc Cliente, dbo.fbusca_docs_po_modal(HOU.Num_Proc_HIM,'1') PO from master_imp_mar MAS
		Join House_Imp_mar HOU on hou.num_proc_mim=mas.num_proc_mim
		Join Pessoa CS on CS.cd_pes=cd_consig_him
		Join Armador ARM on Arm.cd_armador = Mas.cd_armador
		Join Localidade Orig on Orig.cd_local = MAS.cd_org_mim
		Join Localidade Dest on Dest.cd_local = MAS.cd_dst_MIM
--		Join Pessoa SHP on SHP.cd_pes=cd_export_him
		Join Pessoa AGT on AGT.cd_pes=cd_export_mim
		Join LLP_Master LM on MAS.num_proc_mim=LM.num_proc_master
		Where mas.num_proc_mim=@Num_Proc_Master

	Else IF left(@Num_Proc_Master,2)='IA'
		select LM.Num_Proc_Master Num_Proc_Master, 
		LM.ETD_Master ETD, '' Armador, Orig.Nome_local Origem, Dest.Nome_local Destino,

		AGT.nome_raz_soc Agente,Nome_cia_aer Navio,Voo_MiA Viagem,LM.ETA_Master ETA,hou.hawb_hia HAWB, MAS.mawb_mia MAWB,num_proC_hia Job,CS.Nome_Raz_Soc Cliente,dbo.fbusca_docs_po_modal(HOU.Num_Proc_HIA,'1') PO from master_imp_Aer MAS
		Join House_Imp_Aer HOU on hou.num_proc_mia=mas.num_proc_mia
		Join Pessoa CS on CS.cd_pes=cd_consig_hia
		--Join Armador ARM on Arm.cd_armador = Mas.cd_armador
		Join Localidade Orig on Orig.cd_local = MAS.cd_org_mia
		Join Localidade Dest on Dest.cd_local = MAS.cd_dst_MIa
--		Join Pessoa SHP on SHP.cd_pes=cd_export_hia
		Join Pessoa AGT on AGT.cd_pes=cd_export_mia
		Join LLP_Master LM on MAS.num_proc_mia=LM.num_proc_master
		Join Cia_Aerea CIA on CIA.cd_Cia_aer = MAS.cd_cia_aer
		Where mas.num_proc_mia=@Num_Proc_Master

--EXPORT
	Else IF left(@Num_Proc_Master,2)='EM'
		select LM.Num_Proc_Master Num_Proc_Master, 
		LM.ETD_Master ETD, ARM.nome_armador Armador, Orig.Nome_local Origem, Dest.Nome_local Destino,
		AGT.nome_raz_soc Agente,LM.Navio Navio,Num_Viagem Viagem,Lm.ETA_Master ETA,hou.hawb_hem HAWB, MAS.mawb_mem MAWB,num_proC_hem Job,CS.Nome_Raz_Soc Cliente,dbo.fbusca_docs_po_modal(HOU.Num_Proc_HEM,'1') PO from master_exp_mar MAS
		Join House_Exp_mar HOU on hou.num_proc_mem=mas.num_proc_mem
		Join Pessoa CS on CS.cd_pes=cd_export_hem		
		Join Localidade Orig on Orig.cd_local = MAS.cd_org_mem
		Join Localidade Dest on Dest.cd_local = MAS.cd_dst_Mem
--		Join Pessoa SHP on SHP.cd_pes=cd_export_hem
		Join Pessoa AGT on AGT.cd_pes=cd_consig_mem
		Join LLP_Master LM on MAS.num_proc_mem=Lm.num_proc_master
		Left Join Armador ARM on MAS.Cd_Armador	= ARM.Cd_Armador
		Where mas.num_proc_mem=@Num_Proc_Master

	Else IF left(@Num_Proc_Master,2)='EA'
		select LM.Num_Proc_Master Num_Proc_Master, 
		Lm.ETD_Master ETD, '' Armador, Orig.Nome_local Origem, Dest.Nome_local Destino,
		AGT.nome_raz_soc Agente,Nome_cia_aer Navio, Voo_MEA Viagem,Lm.ETA_Master ETA,hou.hawb_hea HAWB, MAS.mawb_mea MAWB,num_proC_hea Job,CS.Nome_Raz_Soc Cliente, dbo.fbusca_docs_po_modal(HOU.Num_Proc_HEA,'1') PO from master_Exp_Aer MAS
		Join House_Exp_Aer HOU on hou.num_proc_mea=mas.num_proc_mea
		Join Pessoa CS on CS.cd_pes=cd_export_hea
		Join Localidade Orig on Orig.cd_local = MAS.cd_org_mea
		Join Localidade Dest on Dest.cd_local = MAS.cd_dst_Mea
--		Join Pessoa SHP on SHP.cd_pes=cd_export_hea
		Join Pessoa AGT on AGT.cd_pes=cd_consig_mea
		Join LLP_Master LM on MAS.num_proc_mea=num_proc_master
		Join Cia_Aerea CIA on CIA.cd_Cia_aer = MAS.cd_cia_aer
		Where mas.num_proc_mea=@Num_Proc_Master




GO
