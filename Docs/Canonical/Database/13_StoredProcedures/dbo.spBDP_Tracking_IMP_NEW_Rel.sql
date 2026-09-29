SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--spBDP_Tracking_IMP_NEW_Rel 'IoCSR20100200101'


CREATE       Procedure [dbo].[spBDP_Tracking_IMP_NEW_Rel] --'car'
(
	@JOB varchar(16)
)
As

	declare @Cd_Grupo as varchar(10)
	set @Cd_Grupo = (select Cd_Pes_Grupo from grupo where Grupo = right(left(@JOB,5),3))

	if left(@JOB,2) = 'IM'
		Begin
			select distinct
				BDPCSR.Nome_Usuario					BDP_CSR,
				UC.nome_usuario						Nome_PO,
				'OCEAN'								Modal,
				@JOB								Ref_BDP,
				CSN.Apelido							Consignee,
				CSN.Num_CPF_CNPJ					CNPJ,
				HOU.MAWB_HIM						Master,
				HOU.HAWB_HIM						House,
				dbo.fBusca_Docs_PO_Modal(@JOB,1)	PO,
				dbo.fBusca_Docs_PO_Modal(@JOB,9)	CustomerPO,
				dbo.fBusca_GMID(@JOB)				Cod_Prod,
				dbo.fBusca_PRODUTO(@JOB)			Produto,
				Org.Nome_Local						Origem,
				Dst.Nome_Local						Destino,
				Nome_Armador						Carrier,
				Navio_HIM							Navio_Voo,
				isnull(dbo.fBusca_Containers_IM(@JOB),
				dbo.fBusca_Volumes(@JOB))			Containers,
				TERM.Nome_Terminal,
				dbo.fBusca_Docs_PO_Modal(@JOB,23)	LI,
				dbo.fBusca_Tarefa(@JOB,20)			Def_LI,
				ETD_LIM								ETD,
				ATD_LIM								ATD,
				ETA_LIM								ETA,
				ATA_LIM								ATA,
				dbo.fBusca_Tarefa(@JOB,16)			ChegadaDOCs,
				dbo.fBusca_Tarefa(@JOB,16)          Chegada_Docs,
				dbo.fBusca_Tarefa(@JOB,28)			Entrada_Terminal,
				dbo.fBusca_Tarefa(@JOB,15)			Presenca_Carga,
				DI.Numero_PO_Him					DI, 
				DI.Data_PO_Him						Data_DI,
				dbo.fBusca_Tarefa(@JOB,4)			Dt_Desemb,
				dbo.fBusca_Docs_PO_Modal(@JOB,3)	DSM_Ref,
				dbo.fBusca_Docs_PO_Modal(@JOB,2)	Num_Invoice,
				Canal_Lim							Canal,
				dbo.fBusca_Tarefa(@JOB,7)			Entr_Docs_Transp,
				dbo.fBusca_Tarefa(@JOB,13)			Entrega_Planta,
				dbo.fBusca_HistoricoDescr(@JOB,0,getdate()) Historico,
				(select top 1 Data_PC from Fatura_CHB where Processo_PC = @JOB order by Data_PC desc) Prest_Contas,
				dbo.fBusca_Tarefa(@JOB,29)			Desova,
				dbo.fBusca_Tarefa(@JOB,27)			Digitacao,
				dbo.fBusca_Containers(@JOB)			Containers,
				dbo.fBusca_TEUS(@JOB)				TEUS,
				dbo.fBusca_Tarefa(@JOB,67)			NFE,
				HOU.Obs_HIM							Notes,
				(select Apelido	from pessoa where cd_pes = @cd_grupo) Nome_Grupo,
				dbo.fBusca_CampoCliente(@JOB, 5)	N_LI,
				isnull(dbo.fBusca_Tarefa(@JOB,59),
				dbo.FBusca_Adto(@JOB))				Sol_Numerario,
				SHP.Apelido							Shipper,
				(case when HOU.Num_Proc_Mim = 'JOB' then null else HOU.Num_Proc_Mim end) Ref_Consolidada,
				TP.NOME_Tp_Oper						Incoterm,
				vd.descricao						Urgente,
				dbo.FBusca_Docs(@JOB,44)			SN_BL_Original,
				dbo.fbusca_docs(@JOB,2)				SN_Invoice,
				dbo.fbusca_docs(@JOB,11)			SN_Packing,
				dbo.fbusca_docs(@JOB,20)			SN_Doc_Embarque,
				dbo.fbusca_docs(@JOB,47)			SN_Shipping,
				dbo.fbusca_docs(@JOB,5)				SN_DI_Number,
				dbo.fbusca_docs(@JOB,41)			SN_AFRMM,
				dbo.fbusca_docs(@JOB,6)				SN_CI_Number,
				dbo.fbusca_docs(@JOB,60)			SN_Prestacao,
				dbo.fBusca_Tarefa_Prev(@JOB,13)		Prev_Entrega,
				dbo.fbusca_campocliente(@JOB,43)	EnvDrafCom
			from
				llp_imp_mar LLP
				Join House_Imp_Mar					HOU on hou.num_proc_HIM=@JOB
				left Join Job_Imp_Mar				JOB on JOB.num_proc_him=@JOB
				left Join Armador					ARM on ARM.cd_armador=JOB.cd_armador
				left Join Pedido_Ship				PS on PS.num_proc=@JOB
				left Join Pedido					PD on PD.cd_pedido=PS.cd_pedido
				left Join Produto_cliente			PC on PC.cd_prod=ps.cd_produto AND PC.cd_cliente = @Cd_Grupo
				left Join Localidade				Org on hou.cd_org_HIM=Org.cd_local
				left Join Localidade				Dst on cd_dst_HIM=DSt.cd_local
				Left Join Terminal					TERM on LLP.Cd_Terminal = TERM.Cd_Terminal
				Left Join PO_HIM					DI on DI.Num_Proc_Him=@JOB and DI.id_dc=5
				Join Pessoa_LLP						PLL on PLL.Cd_Pes=HOU.Cd_Consig_HIM and PLL.Cd_Pes_Grupo=@Cd_Grupo
				Left Join Usuario_Cliente			UC on UC.cd_usuario=PD.PO_Responsible and PD.Cd_Grupo=@Cd_Grupo
				Join Pessoa							CSN on CSN.cd_pes=HOU.Cd_Consig_HIM
				left join Pessoa					SHP on SHP.cd_pes = HOU.cd_export_him
				Left Join PO_HIM					PO on PO.Num_Proc_Him=@JOB and PO.ID_DC='3'
				Left Join PO_HIM					CU on CU.Num_Proc_Him=@JOB and CU.ID_DC='9'
				left join Hist_Geral				HG on HG.HSGProcesso=@JOB and HG.cd_tp_ocor = '28'
				left Join Tipo_Oper					TP on HOU.cd_tp_oper = TP.Cd_tp_oper
				left join campo_processo      		CP on cp.num_proc = @JOB and cp.id_campo=36
				left join verdade					VD on cp.campo_dados = VD.id
				left Join Usuario					BDPCSR on BDPCSR.cd_usuario=job.cd_usuario					
			where
				LLP.Num_proc_LIM = @JOB
				and (PO.Numero_PO_HIM not in ('CANCELLED JOB','PACKAGE RETURN','SAMPLE','FREIGHT FORWARDER') or PO.Numero_PO_HIM is null)
				and (CU.Numero_PO_HIM not in ('CANCELLED JOB','PACKAGE RETURN','SAMPLE','FREIGHT FORWARDER') or CU.Numero_PO_HIM is null)
				and HG.cd_tp_ocor is null
			order by 
				3
		end
	Else If left(@JOB,2) = 'IA'
		Begin
			select distinct 
				BDPCSR.Nome_Usuario					BDP_CSR,
				UC.nome_usuario						Nome_PO,
				'AIR'								Modal,
				@JOB								Ref_BDP,
				CSN.Apelido							Consignee,
				CSN.Num_CPF_CNPJ					CNPJ,
				HOU.MAWB_HIA						Master,
				HOU.HAWB_HIA						House,
				dbo.fBusca_Docs_PO_Modal(@JOB,1)	PO,
				dbo.fBusca_Docs_PO_Modal(@JOB,9)	CustomerPO,
				dbo.fBusca_GMID(@JOB)				Cod_Prod,
				dbo.fBusca_PRODUTO(@JOB)			Produto,
				Org.Nome_Local						Origem,
				Dst.Nome_Local						Destino,
				Nome_Cia_Aer						Carrier,
				Voo_HIA								Navio_Voo,
				isnull(dbo.fBusca_Containers_IM(@JOB),
				dbo.fBusca_Volumes(@JOB))			Containers,
				TERM.Nome_Terminal,
				dbo.fBusca_Docs_PO_Modal(@JOB,23)	LI,
				dbo.fBusca_Tarefa(@JOB,20)			Def_LI,
				ETD_LIA								ETD,
				ATD_LIA								ATD,
				ETA_LIA								ETA,
				ATA_LIA								ATA,
				dbo.fBusca_Tarefa(@JOB,16)			ChegadaDOCs,
				dbo.fBusca_Tarefa(@JOB,16)          Chegada_Docs,
				dbo.fBusca_Tarefa(@JOB,28)			Entrada_Terminal,
				dbo.fBusca_Tarefa(@JOB,15)			Presenca_Carga,
				DI.Numero_PO_HIA					DI, 
				DI.Data_PO_HIA						Data_DI,
				dbo.fBusca_Tarefa(@JOB,4)			Dt_Desemb,
				dbo.fBusca_Docs_PO_Modal(@JOB,3)	DSM_Ref,
				dbo.fBusca_Docs_PO_Modal(@JOB,2)	Num_Invoice,
				Canal_LIA							Canal,
				dbo.fBusca_Tarefa(@JOB,7)			Entr_Docs_Transp,
				dbo.fBusca_Tarefa(@JOB,13)			Entrega_Planta,
				dbo.fBusca_HistoricoDescr(@JOB,0,getdate()) Historico,
				(select top 1 Data_PC from Fatura_CHB where Processo_PC = @JOB order by Data_PC desc) Prest_Contas,
				dbo.fBusca_Tarefa(@JOB,29)			Desova,
				dbo.fBusca_Tarefa(@JOB,27)			Digitacao,
				dbo.fBusca_Containers(@JOB)			Containers,
				dbo.fBusca_TEUS(@JOB)				TEUS,
				dbo.fBusca_Tarefa(@JOB,67)			NFE,
				HOU.Obs_HIA							Notes,
				(select Apelido	from pessoa where cd_pes = @cd_grupo) Nome_Grupo,
				dbo.fBusca_CampoCliente(@JOB, 5)	N_LI,
				isnull(dbo.fBusca_Tarefa(@JOB,59),
				dbo.FBusca_Adto(@JOB))				Sol_Numerario,
				SHP.Apelido							Shipper,
				(case when HOU.Num_Proc_Mia = 'JOB' then null else HOU.Num_Proc_Mia end)	Ref_Consolidada,
				TP.NOME_Tp_Oper						Incoterm,
				vd.descricao						Urgente,
				dbo.FBusca_Docs(@JOB,44)			SN_BL_Original,
				dbo.fbusca_docs(@JOB,2)				SN_Invoice,
				dbo.fbusca_docs(@JOB,11)			SN_Packing,
				dbo.fbusca_docs(@JOB,20)			SN_Doc_Embarque,
				dbo.fbusca_docs(@JOB,47)			SN_Shipping,
				dbo.fbusca_docs(@JOB,5)				SN_DI_Number,
				dbo.fbusca_docs(@JOB,41)			SN_AFRMM,
				dbo.fbusca_docs(@JOB,6)				SN_CI_Number,
				dbo.fbusca_docs(@JOB,60)			SN_Prestacao,
				dbo.fBusca_Tarefa_Prev(@JOB,13)		Prev_Entrega,
				dbo.fbusca_campocliente(@JOB,43)	EnvDrafCom
			from
				llp_imp_Aer LLP
				Join House_Imp_Aer						HOU on HOU.num_proc_HIA=@JOB
				left Join Job_Imp_Aer					JOB on JOB.num_proc_HIA=@JOB
				left Join Cia_Aerea						CIA on CIA.Cd_Cia_Aer=JOB.Cd_Cia_Aer
				left Join Pedido_Ship					PS on PS.num_proc=@JOB
				left Join Pedido						PD on PD.cd_pedido=PS.cd_pedido
				left Join Produto_cliente				PC on PC.cd_prod=ps.cd_produto and PC.cd_cliente = @Cd_Grupo
				left Join Localidade					Org on hou.cd_org_HIA=Org.cd_local
				left Join Localidade					Dst on cd_dst_HIA=DSt.cd_local
				Left Join Terminal						TERM on LLP.Cd_Terminal = TERM.Cd_Terminal
				Left Join PO_HIA						DI on DI.Num_Proc_HIA=@JOB and DI.id_dc=5
				Join Pessoa_LLP							PLL on PLL.Cd_Pes=HOU.Cd_Consig_HIA and PLL.Cd_Pes_Grupo=@Cd_Grupo
				Left Join Usuario_Cliente				UC on UC.cd_usuario=PD.PO_Responsible and PD.Cd_Grupo=@Cd_Grupo
				Join Pessoa								CSN on CSN.cd_pes=HOU.Cd_Consig_HIA
				left join Pessoa						SHP on SHP.cd_pes = HOU.cd_export_hia
				Left Join PO_HiA						PO on PO.Num_Proc_HiA=@JOB and PO.ID_DC='3'
				Left Join PO_HiA						CU on CU.Num_Proc_HiA=@JOB and CU.ID_DC='9'
				left join Hist_Geral					HG on HG.HSGProcesso=@JOB and HG.cd_tp_ocor = '28'
				left Join Tipo_Oper						TP on HOU.cd_tp_oper = TP.Cd_tp_oper
				left join campo_processo      			CP on CP.Num_Proc=@JOB and cp.id_campo=36
				left join verdade						VD on cp.campo_dados = VD.id
				left Join Usuario						BDPCSR on BDPCSR.cd_usuario=job.cd_usuario					
			where
				LLP.Num_proc_LIA = @JOB
				and (PO.Numero_PO_HiA not in ('CANCELLED JOB','PACKAGE RETURN','SAMPLE','FREIGHT FORWARDER') or PO.Numero_PO_HiA is null)
				and (CU.Numero_PO_HiA not in ('CANCELLED JOB','PACKAGE RETURN','SAMPLE','FREIGHT FORWARDER') or CU.Numero_PO_HiA is null)
				and HG.cd_tp_ocor is null
			order by 
				3
		End

	Else If left(@JOB,2) = 'IO'
		Begin
			select distinct
				BDPCSR.Nome_usuario								BDP_CSR,
				UC.nome_usuario									Nome_PO,
				'Other'											Modal,
				HOU.Num_Proc_HIo								Ref_BDP,
				CSN.Apelido										Consignee,
				CSN.Num_CPF_CNPJ								CNPJ,
				HOU.MAWB_HIo									Master,
				HOU.HAWB_HIo									House,
				dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HIo,1)	PO,
				dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HIo,9)	CustomerPO,
				dbo.fBusca_GMID(HOU.Num_Proc_HIo)				Cod_Prod,
				dbo.fBusca_PRODUTO(HOU.Num_Proc_HIo)			Produto,
				Org.Nome_Local									Origem,
				Dst.Nome_Local									Destino,
				CIA.Apelido										Carrier,
				Voo_HIo											Navio_Voo,
				isnull(dbo.fBusca_Containers_IM(HOU.Num_Proc_HIo),
				dbo.fBusca_Volumes(HOU.Num_Proc_HIo))			Containers,
				TERM.Nome_Terminal,
				dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HIo,23)	LI,
				dbo.fBusca_Tarefa(hou.num_proc_HIo,20)			Def_LI,
				ETD_LIo											ETD,
				ATD_LIo											ATD,
				ETA_LIo											ETA,
				ATA_LIo											ATA,
				dbo.fBusca_Tarefa(hou.Num_Proc_HIO,16)			ChegadaDOCs,
				dbo.fBusca_Tarefa(HOU.Num_Proc_HIO,16)          Chegada_Docs,
				dbo.fBusca_Tarefa(hou.num_proc_HIO,28)			Entrada_Terminal,
				dbo.fBusca_Tarefa(hou.num_proc_HIO,15)			Presenca_Carga,
				DI.Numero_PO_HIo								DI, 
				DI.Data_PO_HIo									Data_DI,
				dbo.fBusca_Tarefa(hou.num_proc_HIO,4)			Dt_Desemb,
				dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HIO,3)	DSM_Ref,
				dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HIO,2)	Num_Invoice,
				Canal_LIo										Canal,
				dbo.fBusca_Tarefa(hou.num_proc_HIo,7)			Entr_Docs_Transp,
				dbo.fBusca_Tarefa(hou.num_proc_HIo,13)			Entrega_Planta,
				dbo.fBusca_HistoricoDescr(hou.num_proc_HIo,0,getdate()) Historico,
				(select top 1 Data_PC from Fatura_CHB where Processo_PC = @JOB order by Data_PC desc) Prest_Contas,
				dbo.fBusca_Tarefa(hou.num_proc_hio,29)			Desova,
				dbo.fBusca_Tarefa(hou.num_proc_hio,27)			Digitacao,
				dbo.fBusca_Containers(hou.num_proc_hio)			Containers,
		--		dbo.Qty_Container(hou.num_proc_hio)				Qtde,
				dbo.fBusca_TEUS(hou.num_proc_hio)				TEUS,
				dbo.fBusca_Tarefa(hou.num_proc_hio,67)			NFE,
				HOU.Obs_HIo Notes,
				(select Apelido	from pessoa where cd_pes = @cd_grupo) Nome_Grupo,
				dbo.fBusca_CampoCliente(HOU.Num_Proc_Hio, 5)	N_LI,
				isnull(dbo.fBusca_Tarefa(hou.num_proc_hio,59),
				dbo.FBusca_Adto(hou.num_proc_hio))				Sol_Numerario,
				SHP.Apelido										Shipper,
		--		PDET.UoM										Unid,
				''	Ref_Consolidada,
				TP.NOME_Tp_Oper									Incoterm,
				vd.descricao									Urgente,
				dbo.FBusca_Docs(hou.num_proc_hio,44)			SN_BL_Original,
				dbo.fbusca_docs(hou.num_proc_hio,2)				SN_Invoice,
				dbo.fbusca_docs(hou.num_proc_hio,11)			SN_Packing,
				dbo.fbusca_docs(hou.num_proc_hio,20)			SN_Doc_Embarque,
				dbo.fbusca_docs(hou.num_proc_hio,47)			SN_Shipping,
				dbo.fbusca_docs(hou.num_proc_hio,5)				SN_DI_Number,
				dbo.fbusca_docs(hou.num_proc_hio,41)			SN_AFRMM,
				dbo.fbusca_docs(hou.num_proc_hio,6)				SN_CI_Number,
				dbo.fbusca_docs(hou.num_proc_hio,60)			SN_Prestacao,
				dbo.fBusca_Tarefa_Prev(hou.num_proc_hio,13)		Prev_Entrega,
				dbo.fbusca_campocliente(hou.num_proc_hio,43)	EnvDrafCom
			from
				llp_imp_out LLP
				Join House_Imp_out					HOU on hou.num_proc_HIo = @JOB
				left Join Pedido_Ship				PS on PS.num_proc=@JOB
				left Join Pedido					PD on PD.cd_pedido=PS.cd_pedido
				left Join Produto_cliente			PC on PC.cd_prod=ps.cd_produto and PC.cd_cliente=@Cd_Grupo
				left Join Localidade				Org on hou.cd_org_HIo=Org.cd_local
				left Join Localidade				Dst on cd_dst_HIo=DSt.cd_local
				Left Join Terminal					TERM on LLP.Cd_Terminal = TERM.Cd_Terminal
				Left Join PO_HIo					DI on DI.Num_Proc_HIo=@JOB and DI.id_dc=5
				Join Pessoa_LLP						PLL on PLL.Cd_Pes=HOU.Cd_Consig_HIo and PLL.Cd_Pes_Grupo=@Cd_Grupo
				Left Join Usuario_Cliente			UC on UC.cd_usuario=PD.PO_Responsible and PD.Cd_Grupo=@Cd_Grupo
				Join Pessoa							CSN on CSN.cd_pes=HOU.Cd_Consig_HIo
				left Join pessoa					CIA on CIA.cd_pes=llp.cd_carrier
				left join Pessoa					SHP on SHP.cd_pes = HOU.cd_export_hio
				Left Join PO_HIO					PO on PO.Num_Proc_Hio=@JOB and PO.ID_DC='3'
				Left Join PO_HIO					CU on CU.Num_Proc_Hio=@JOB and CU.ID_DC='9'
				left join Hist_Geral				HG on HG.HSGProcesso=@JOB and HG.cd_tp_ocor = '28'
				left Join Tipo_Oper					TP on HOU.cd_tp_oper = TP.Cd_tp_oper
				left join campo_processo      		CP on cp.num_proc=@JOB and cp.id_campo=36
				left join verdade					VD on cp.campo_dados = VD.id
				left Join Usuario					BDPCSR on BDPCSR.cd_usuario=llp.cd_usuario
			where
				LLP.Num_proc_LIO = @JOB
				and (PO.Numero_PO_Hio not in ('CANCELLED JOB','PACKAGE RETURN','SAMPLE','FREIGHT FORWARDER') or PO.Numero_PO_Hio is null)
				and (CU.Numero_PO_Hio not in ('CANCELLED JOB','PACKAGE RETURN','SAMPLE','FREIGHT FORWARDER') or CU.Numero_PO_Hio is null)
				and HG.cd_tp_ocor is null
			order by 
				3
		End







GO
