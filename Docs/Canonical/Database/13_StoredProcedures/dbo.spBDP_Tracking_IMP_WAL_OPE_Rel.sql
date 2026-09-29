SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO









CREATE  Procedure [dbo].[spBDP_Tracking_IMP_WAL_OPE_Rel] --'WAL'
(
@Grupo as varchar(3)
)

As
	declare @Cd_Grupo as varchar(10)
	set @Cd_Grupo = (select Cd_Pes_Grupo from grupo where Grupo = @Grupo)

	select
		convert(datetime,dt_emis_him,105)				Dt_Ins,
		UC.nome_usuario									Nome_PO,
		'SEA'											Modal,
		HOU.Num_Proc_HIM								Ref_BDP,
		CSN.Apelido										Consignee,
		CSN.Num_CPF_CNPJ								CNPJ,
		HOU.MAWB_HIM									Master,
		HOU.HAWB_HIM									House,
		dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HIM,1)	PO,
		dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HIM,9)	Evento,
--		PC.cd_proc_Cliente								Cod_Prod,
--		PC.Produto_Descr								Produto,
		max(PCHB.Tipo_LI)								Tipo_LI,
		max(PCHB.Import_License)						Import_License,
		Org.Nome_Local									Origem,
		Org.Pais_Local									Pais_Origem,
		Dst.Nome_Local									Destino,
		Nome_Armador									Carrier,
		Navio_HIM										Navio_Voo,
		dbo.fBusca_Containers_IM_NUMERO(HOU.Num_Proc_HIM) Containers,
		dbo.fBusca_Containers_Inf (HOU.Num_Proc_HIM,'C') Capacidade_Container,
		dbo.fBusca_Containers_Inf (HOU.Num_Proc_HIM,'20B') + 
		dbo.fBusca_Containers_Inf (HOU.Num_Proc_HIM,'20D') + 
		dbo.fBusca_Containers_Inf (HOU.Num_Proc_HIM,'20F') + 
		dbo.fBusca_Containers_Inf (HOU.Num_Proc_HIM,'20O') Container_20,
		dbo.fBusca_Containers_Inf (HOU.Num_Proc_HIM,'40B') +
		dbo.fBusca_Containers_Inf (HOU.Num_Proc_HIM,'40D') +
		dbo.fBusca_Containers_Inf (HOU.Num_Proc_HIM,'40F') +
		dbo.fBusca_Containers_Inf (HOU.Num_Proc_HIM,'40O') Container_40,
		dbo.fBusca_Containers_Inf (HOU.Num_Proc_HIM,'40H') Container_40HC,
		dbo.fBusca_Containers_Inf (HOU.Num_Proc_HIM,'40N') Container_40NOR,
		dbo.fBusca_Containers_Inf (HOU.Num_Proc_HIM,'20R') Container_20Ref, 
		dbo.fBusca_Containers_Inf (HOU.Num_Proc_HIM,'40R') Container_40Ref,
		TERM.Nome_Terminal,
		dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HIM,23)	LI,
		dbo.fBusca_Tarefa(hou.num_proc_him,20)			Def_LI,
		ETD_LIM											ETD,
		ATD_LIM											ATD,
		ETA_LIM											ETA,
		ATA_LIM											ATA,
		dbo.fBusca_Tarefa(hou.num_proc_him,28)			Entrada_Terminal,
		dbo.fBusca_Tarefa(hou.num_proc_him,15)			Presenca_Carga,
		DI.Numero_PO_Him								DI, 
		DI.Data_PO_Him									Data_DI,
		dbo.fBusca_Tarefa(hou.num_proc_him,4)			Dt_Desemb,
		Canal_Lim										Canal,
		dbo.fBusca_Tarefa(hou.num_proc_him,7)			Entr_Docs_Transp,
		dbo.fBusca_Tarefa(hou.num_proc_him,13)			Entrega_Planta,
		dbo.fBusca_HistoricoDescr(hou.num_proc_him,0,getdate()) Historico,
		max(FCHB.Data_PC)								Prest_Contas,
		PP.Nome_Raz_Soc									Exportador,
		dbo.fBusca_Tarefa(hou.num_proc_him,43)			EnvCustoEst,
		dbo.fBusca_Tarefa(hou.num_proc_him,69)			EnvCustoRev,
		dbo.fBusca_Tarefa(hou.num_proc_him,5)			Booking,
		dbo.fBusca_Tarefa(hou.num_proc_him,47)			Capa,
		dbo.fBusca_Tarefa(hou.num_proc_him,44)			Label,
		dbo.fBusca_Tarefa(hou.num_proc_him,45)			Ship,
		TC.Nome_tp_carga								Carga,
		dbo.fBusca_Tarefa(hou.num_proc_him,48)			Pan,
		dbo.fBusca_Tarefa(hou.num_proc_him,49)			PL_INV,
		HOU.Vol_Tot_HIM									Cubagem,
		PD.Vlr_Pedido									FOB,
		dbo.fBusca_Tarefa(hou.num_proc_him,43)			Env_Custo,
		JP1.DataInicio									ETDInicial,
		JP1.DataFinal									ETDFinal,
		isnull(JP2.DataInicio, JP1.DataInicio)			ETAInicial,
		isnull(JP2.DataFinal, JP1.DataFinal)			ETAFinal,
		JP3.DataInicio									CDInicial,
		JP3.DataFinal									CDFinal,
		PD.Incoterm,
		isnull(dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HIM,38),'S/Nº')	Proforma,
		HOU.Peso_Liquido_HIM							Peso,
		dbo.fNCM(hou.num_proc_him)						NCM,
		dbo.fBusca_Tarefa(hou.num_proc_him,58)			Sol_Booking,
		dbo.fBusca_CampoCliente(HOU.Num_Proc_HIM,11)	Divisao,
		BU.Nome_Raz_Soc									BUYER,
		sum(PS.Qty)										Qty_Item,
		PD.cd_tp_moeda									Moeda_Origem,
		HOU.cd_tp_moeda									Moeda_Frete,
		HOU.Vlr_Frete_efet_HIM							Valor_Frete,
		'Não'											Cota,
		dbo.fBusca_Tarefa(hou.num_proc_him,16)			Chegada_Docs,
		DTA.Data_PO_HIM									Data_DTA,
		HOU.Obs_HIM										Obs,
		dbo.fBusca_CampoCliente(HOU.Num_Proc_HIM,31)	TX_DI,
		dbo.fBusca_CampoCliente(HOU.Num_Proc_HIM,8)		Assistencia,
		PD.cd_tp_moeda									Moeda_Origem,
		AR.Nome_Raz_Soc									Forwarder,
		dbo.fBusca_CampoCliente(HOU.Num_Proc_HIM,10)	Termo_pgto,
		dbo.fBusca_Tarefa(hou.num_proc_him,29)			Carga_Desovada,
		dbo.fBusca_CampoCliente(HOU.Num_Proc_HIM,7)		Certificado,
		dbo.fBusca_CampoCliente(HOU.Num_Proc_HIM,12)	Conforme,
		Nome_Terminal									Recinto,
		convert(datetime, dbo.fBusca_CampoCliente(HOU.Num_Proc_HIM,14), 105)	Data_Inmetro,
		convert(datetime, dbo.fBusca_CampoCliente(HOU.Num_Proc_HIM,15), 105)	Data_Amostra,
		convert(datetime, dbo.fBusca_CampoCliente(HOU.Num_Proc_HIM,16), 105)	Data_Certificado,
		dbo.fBusca_CampoCliente(HOU.Num_Proc_HIM,17)	Booking_Sim_Nao,
		dbo.fBusca_CampoCliente(HOU.Num_Proc_HIM,18)	Evento_Inicial,
		dbo.fBusca_CampoCliente(HOU.Num_Proc_HIM,19)	Evento_Atual,
		dbo.fBusca_CampoCliente(HOU.Num_Proc_HIM,20)	Baixa_Fiel,
		dbo.fBusca_CampoCliente(HOU.Num_Proc_HIM,21)	Preco_Minimo,
		dbo.fBusca_CampoCliente(HOU.Num_Proc_HIM,22)	Cebri,
		dbo.fBusca_CampoCliente(HOU.Num_Proc_HIM,23)	GP,
		dbo.fBusca_CampoCliente(HOU.Num_Proc_HIM,24)	Area,
		dbo.fBusca_Tarefa(hou.num_proc_him,50)			Recebimento_Proc,
		Por_Org.Nome_Local								Por_Org,
		dbo.fBusca_CampoCliente(HOU.Num_Proc_HIM,26)	Buyer2,
		Max(hsgdata)									Cancelamento,
		dbo.fBusca_Tarefa(hou.num_proc_him,46)			Sol_LI,
		dbo.fBusca_CampoCliente(HOU.Num_Proc_HIM,9)		Avaria,
		dbo.fBusca_CampoCliente(HOU.Num_Proc_HIM,30)	Avaria_Retorno,
		dbo.fBusca_CampoCliente(HOU.Num_Proc_HIM,27)	Consolidacao,
		dbo.fBusca_CampoCliente(HOU.Num_Proc_HIM,13)	Departamento,
		Hou.Num_proc_Mim								Num_Cons,
		dbo.fBusca_Tarefa(hou.num_proc_him,60)			Abertura_Pasta,
		dbo.fBusca_Tarefa(hou.num_proc_him,73)			Cdgo_Item_WAL,
		dbo.fBusca_Tarefa(hou.num_proc_him,72)			Solicita_NF,
		dbo.fBusca_Tarefa(hou.num_proc_him,74)			Cdgo_Item_BDP,
		NULL											LI_Sub,
		NULL											DI_Retificada,
		NULL											Optn_Docs_Orig,
		dbo.fBusca_Tarefa(hou.num_proc_him,41)			Aprov_Draft,
		dbo.fBusca_Tarefa(hou.num_proc_him,11)			Dt_Emissao_NF,
		dbo.fBusca_Tarefa(hou.num_proc_him,50)			Recb_Proc,
		dbo.fBusca_Tarefa(hou.num_proc_him,27)			Draft_DI,
		dbo.fBusca_Tarefa(hou.num_proc_him,21)			Lib_BL
	from	
		llp_imp_mar LLP
		Join House_imp_mar				Hou on LLP.num_proc_LIM=hou.num_proc_HIM
		left Join Job_Imp_Mar			JOB on JOB.num_proc_him=llp.num_proc_lim
		left Join Armador				ARM on ARM.cd_armador=job.cd_armador
		left Join Pedido_Ship			PS on PS.num_proc=num_proc_lim
--		Left Join Pedido_Det			PDET on PDET.cd_produto=PS.cd_produto and PDET.cd_pedido=PS.cd_pedido and pdet.lote=ps.lote and pdet.item=ps.item
		left Join Pedido				PD on PD.cd_pedido=PS.cd_pedido and PD.cd_Grupo=@Cd_Grupo
--		left Join Produto_cliente		PC on PC.cd_prod=ps.cd_produto and PC.cd_cliente=@cd_grupo
		left Join Produto_CHB			PCHB on PCHB.cd_prod=PS.cd_produto
		left Join Localidade			Org on CD_Org_him=Org.cd_local
		left Join Localidade			Dst on cd_dst_HIM=DSt.cd_local
		left join Localidade			Por_Org on cd_org_him = Por_Org.cd_local
		Left Join Terminal				TERM on LLP.Cd_Terminal = TERM.Cd_Terminal
		Left Join PO_HIM				DI on DI.Num_Proc_Him=hou.num_proc_him and DI.id_dc=5
		left join PO_HIM				DTA on DTA.Num_Proc_Him = HOU.Num_Proc_Him and DTA.ID_DC=45
		Join Pessoa_LLP					PLL on PLL.Cd_Pes=HOU.Cd_Consig_HIM and PLL.Cd_Pes_Grupo=@Cd_Grupo
		Left Join Usuario_Cliente		UC on UC.cd_usuario=isnull(PD.PO_Responsible, PD.cd_csrid) and UC.Cd_Cliente=@Cd_Grupo
		Join Pessoa						CSN on CSN.cd_pes=HOU.Cd_Consig_HIM
		left Join Fatura_CHB			FCHB on HOU.Num_Proc_HIM = FCHB.Processo_PC or HOU.Num_Proc_MIM = FCHB.Processo_PC
		Join Pessoa						PP on PP.cd_pes=cd_export_him
		left join Tipo_Carga			TC on TC.cd_tp_carga=LLP.cd_tp_carga
		Left join janela_processos		JP1 on JP1.Num_Proc = HOU.Num_Proc_HIM and JP1.ID_Janela = '1'
		Left join janela_processos		JP2 on JP2.Num_Proc = HOU.Num_Proc_HIM and JP2.ID_Janela = '2'
		Left join janela_processos		JP3 on JP3.Num_Proc = HOU.Num_Proc_HIM and JP3.ID_Janela = '3'
		left join proc_ncm				NCM on NCM.Num_Proc = hou.num_proc_him
--		left join de_para_produto		DPP on PC.Cd_Proc_Cliente = DPP.GMID
		left join Pessoa				BU on PD.CD_Buyer = BU.Cd_Pes
--		left join nota_cliente			NC on NC.Num_Proc = HOU.Num_Proc_HIM
		left join Pessoa				AR on AR.cd_pes = JOB.Cd_agente
		Left Join Hist_Geral			CNL on num_proc_lim=CNL.hsgprocesso and cd_tp_ocor='28'
	where 
		CNL.hsgprocesso is null
		and (dbo.fBusca_Tarefa(hou.num_proc_him,13) is null) --and (dbo.fBusca_Tarefa(hou.num_proc_him,13) > '2009-12-01'
		 
	group by
--		PDET.Item,	
		UC.nome_usuario,
		HOU.Num_Proc_HIM,
		HOU.HAWB_HIM,HOU.MAWB_HIM,
		CSN.Apelido,
		CSN.Num_CPF_CNPJ,
		Org.Nome_Local,
		Org.Pais_local,
		Dst.Nome_Local,
		Nome_Armador,
		Navio_HIM,
		TERM.Nome_Terminal,
		ETD_LIM,
		ATD_LIM,
		ETA_LIM,
		ATA_LIM,
		DI.Numero_PO_Him, 
		DI.Data_PO_Him,
		Canal_Lim,	
		dt_emis_him,
		PP.Nome_Raz_Soc,
		TC.Nome_tp_carga,
		HOU.Vol_Tot_HIM,
		PD.Vlr_Pedido,
		JP1.DataInicio,
		JP1.DataFinal,
		JP2.DataInicio,
		JP2.DataFinal,
		JP3.DataInicio,
		JP3.DataFinal,
--		PC.cd_proc_Cliente,
--		PC.Produto_Descr,
--		PCHB.Tipo_LI,
--		PCHB.Import_License,
		PD.Incoterm,
		HOU.Peso_Liquido_HIM,
--		PC.NCM_Cliente,
--		DPP.Value_Center_Descr,
		BU.Nome_Raz_Soc,
		PD.cd_tp_moeda,
		HOU.cd_tp_moeda,
		HOU.Vlr_Frete_efet_HIM,
		DTA.Data_PO_HIM,
		HOU.Obs_HIM,
--		NC.Paridade,
		AR.Nome_Raz_Soc,
		PD.cd_tp_moeda,
		PD.Cd_Pais_Org,
		Por_Org.Nome_Local,
		HOU.Num_proc_Mim
	
UNION
	select
		convert(datetime,dt_emis_HIA,105)				Dt_Ins,
		UC.nome_usuario									Nome_PO,
		'AIR'											Modal,
		HOU.Num_Proc_HIA								Ref_BDP,
		CSN.Apelido										Consignee,
		CSN.Num_CPF_CNPJ								CNPJ,
		HOU.MAWB_HIA									Master,
		HOU.HAWB_HIA									House,
		dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HIA,1)	PO,
		dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HIA,9)	Evento,
--		PC.cd_proc_Cliente								Cod_Prod,
--		PC.Produto_Descr								Produto,
		max(PCHB.Tipo_LI)								Tipo_LI,
		max(PCHB.Import_License)						Import_License,
		Org.Nome_Local									Origem,
		Org.Pais_Local									Pais_Origem,
		Dst.Nome_Local									Destino,
		Nome_Cia_Aer									Carrier,
		Voo_HIA											Navio_Voo,
		dbo.fBusca_Containers_IM_NUMERO(HOU.Num_Proc_HIA) Containers,
		dbo.fBusca_Containers_Inf (HOU.Num_Proc_HIA,'C') Capacidade_Container,
		dbo.fBusca_Containers_Inf (HOU.Num_Proc_HIA,'20B') + 
		dbo.fBusca_Containers_Inf (HOU.Num_Proc_HIA,'20D') + 
		dbo.fBusca_Containers_Inf (HOU.Num_Proc_HIA,'20F') + 
		dbo.fBusca_Containers_Inf (HOU.Num_Proc_HIA,'20O') Container_20,
		dbo.fBusca_Containers_Inf (HOU.Num_Proc_HIA,'40B') +
		dbo.fBusca_Containers_Inf (HOU.Num_Proc_HIA,'40D') +
		dbo.fBusca_Containers_Inf (HOU.Num_Proc_HIA,'40F') +
		dbo.fBusca_Containers_Inf (HOU.Num_Proc_HIA,'40O') Container_40,
		dbo.fBusca_Containers_Inf (HOU.Num_Proc_HIA,'40H') Container_40HC,
		dbo.fBusca_Containers_Inf (HOU.Num_Proc_HIA,'40N') Container_40NOR,
		dbo.fBusca_Containers_Inf (HOU.Num_Proc_HIA,'20R') Container_20Ref, 
		dbo.fBusca_Containers_Inf (HOU.Num_Proc_HIA,'40R') Container_40Ref,
		TERM.Nome_Terminal,
		dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HIA,23)	LI,
		dbo.fBusca_Tarefa(hou.num_proc_HIA,20)			Def_LI,
		ETD_LIA											ETD,
		ATD_LIA											ATD,
		ETA_LIA											ETA,
		ATA_LIA											ATA,
		dbo.fBusca_Tarefa(hou.num_proc_HIA,28)			Entrada_Terminal,
		dbo.fBusca_Tarefa(hou.num_proc_HIA,15)			Presenca_Carga,
		DI.Numero_PO_HIA								DI, 
		DI.Data_PO_HIA									Data_DI,
		dbo.fBusca_Tarefa(hou.num_proc_HIA,4)			Dt_Desemb,
		Canal_LIA										Canal,
		dbo.fBusca_Tarefa(hou.num_proc_HIA,7)			Entr_Docs_Transp,
		dbo.fBusca_Tarefa(hou.num_proc_HIA,13)			Entrega_Planta,
		dbo.fBusca_HistoricoDescr(hou.num_proc_HIA,0,getdate()) Historico,
		max(FCHB.Data_PC)								Prest_Contas,
		PP.Nome_Raz_Soc									Exportador,
		dbo.fBusca_Tarefa(hou.num_proc_HIA,43)			EnvCustoEst,
		dbo.fBusca_Tarefa(hou.num_proc_HIA,69)			EnvCustoRev,
		dbo.fBusca_Tarefa(hou.num_proc_HIA,5)			Booking,
		dbo.fBusca_Tarefa(hou.num_proc_HIA,47)			Capa,
		dbo.fBusca_Tarefa(hou.num_proc_HIA,44)			Label,
		dbo.fBusca_Tarefa(hou.num_proc_HIA,45)			Ship,
		''												Carga,
		dbo.fBusca_Tarefa(hou.num_proc_HIA,48)			Pan,
		dbo.fBusca_Tarefa(hou.num_proc_HIA,49)			PL_INV,
		HOU.Vol_Tot_HIA									Cubagem,
		PD.Vlr_Pedido									FOB,
		dbo.fBusca_Tarefa(hou.num_proc_HIA,43)			Env_Custo,
		JP1.DataInicio									ETDInicial,
		JP1.DataFinal									ETDFinal,
		isnull(JP2.DataInicio, JP1.DataInicio)			ETAInicial,
		isnull(JP2.DataFinal, JP1.DataFinal)			ETAFinal,
		JP3.DataInicio									CDInicial,
		JP3.DataFinal									CDFinal,
		PD.Incoterm,
		isnull(dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HIA,38),'S/Nº')	Proforma,
		HOU.Peso_REAL_HIA								Peso,
		dbo.fNCM(hou.num_proc_hia)								NCM,
		dbo.fBusca_Tarefa(hou.num_proc_HIA,58)			Sol_Booking,
		dbo.fBusca_CampoCliente(HOU.Num_Proc_HIA,11)	Divisao,
		BU.Nome_Raz_Soc									BUYER,
		Max(PS.Qty)										Qty_Item,
		PD.cd_tp_moeda									Moeda_Origem,
		HOU.cd_tp_moeda									Moeda_Frete,
		HOU.Vlr_Frete_efet_HIA							Valor_Frete,
		'Não'											Cota,
		dbo.fBusca_Tarefa(hou.num_proc_HIA,16)			Chegada_Docs,
		DTA.Data_PO_HIA									Data_DTA,
		HOU.Obs_HIA										Obs,
		dbo.fBusca_CampoCliente(HOU.Num_Proc_HIA,31)	TX_DI,
		dbo.fBusca_CampoCliente(HOU.Num_Proc_HIA,8)		Assistencia,
		PD.cd_tp_moeda									Moeda_Origem,
		AR.Nome_Raz_Soc									Forwarder,
		dbo.fBusca_CampoCliente(HOU.Num_Proc_HIA,10)	Termo_pgto,
		dbo.fBusca_Tarefa(hou.num_proc_HIA,29)			Carga_Desovada,
		dbo.fBusca_CampoCliente(HOU.Num_Proc_HIA,7)		Certificado,
		dbo.fBusca_CampoCliente(HOU.Num_Proc_HIA,12)	Conforme,
		Nome_Terminal									Recinto,
		convert(datetime, dbo.fBusca_CampoCliente(HOU.Num_Proc_HIA,14), 105)	Data_Inmetro,
		convert(datetime, dbo.fBusca_CampoCliente(HOU.Num_Proc_HIA,15), 105)	Data_Amostra,
		convert(datetime, dbo.fBusca_CampoCliente(HOU.Num_Proc_HIA,16), 105)	Data_Certificado,
		dbo.fBusca_CampoCliente(HOU.Num_Proc_HIA,17)	Booking_Sim_Nao,
		dbo.fBusca_CampoCliente(HOU.Num_Proc_HIA,18)	Evento_Inicial,
		dbo.fBusca_CampoCliente(HOU.Num_Proc_HIA,19)	Evento_Atual,
		dbo.fBusca_CampoCliente(HOU.Num_Proc_HIA,20)	Baixa_Fiel,
		dbo.fBusca_CampoCliente(HOU.Num_Proc_HIA,21)	Preco_Minimo,
		dbo.fBusca_CampoCliente(HOU.Num_Proc_HIA,22)	Cebri,
		dbo.fBusca_CampoCliente(HOU.Num_Proc_HIA,23)	GP,
		dbo.fBusca_CampoCliente(HOU.Num_Proc_HIA,24)	Area,
		dbo.fBusca_Tarefa(hou.num_proc_HIA,50)			Recebimento_Proc,
		Por_Org.Nome_Local								Por_Org,
		dbo.fBusca_CampoCliente(HOU.Num_Proc_HIA,26)	Buyer2,
		Max(hsgdata)									Cancelamento,
		dbo.fBusca_Tarefa(hou.num_proc_HIA,46)			Sol_LI,
		dbo.fBusca_CampoCliente(HOU.Num_Proc_HIA,9)		Avaria,
		dbo.fBusca_CampoCliente(HOU.Num_Proc_HIA,30)	Avaria_Retorno,
		dbo.fBusca_CampoCliente(HOU.Num_Proc_HIA,27)	Consolidacao,
		dbo.fBusca_CampoCliente(HOU.Num_Proc_HIA,13)	Departamento,
		Hou.Num_proc_HIA								Num_Cons,
		dbo.fBusca_Tarefa(hou.num_proc_hia,60)			Abertura_Pasta,
		dbo.fBusca_Tarefa(hou.num_proc_hia,73)			Cdgo_Item_WAL,
		dbo.fBusca_Tarefa(hou.num_proc_hia,72)			Solicita_NF,
		dbo.fBusca_Tarefa(hou.num_proc_hia,74)			Cdgo_Item_BDP,
		NULL											LI_Sub,
		NULL											DI_Retificada,
		NULL											Optn_Docs_Orig,
		dbo.fBusca_Tarefa(hou.num_proc_hia,41)			Aprov_Draft,
		dbo.fBusca_Tarefa(hou.num_proc_hia,11)			Dt_Emissao_NF,
		dbo.fBusca_Tarefa(hou.num_proc_hia,50)			Recb_Proc,
		dbo.fBusca_Tarefa(hou.num_proc_hia,27)			Draft_DI,
		dbo.fBusca_Tarefa(hou.num_proc_hia,21)			Lib_BL
	from	
		LLP_Imp_Aer LLP
		Join House_Imp_Aer				Hou on LLP.num_proc_LIA=hou.num_proc_HIA
		left Join Job_Imp_Aer			JOB on JOB.num_proc_HIA=llp.num_proc_LIA
		left Join Cia_Aerea				CIA on CIA.Cd_Cia_Aer=JOB.Cd_Cia_Aer
		left Join Pedido_Ship			PS on PS.num_proc=num_proc_LIA
--		Left Join Pedido_Det			PDET on PDET.cd_produto=PS.cd_produto and PDET.cd_pedido=PS.cd_pedido and pdet.lote=ps.lote and pdet.item=ps.item
		left Join Pedido				PD on PD.cd_pedido=PS.cd_pedido and PD.cd_Grupo=@Cd_Grupo
--		left Join Produto_cliente		PC on PC.cd_prod=ps.cd_produto and PC.cd_cliente=@cd_grupo
		left Join Produto_CHB			PCHB on PCHB.cd_prod=PS.cd_produto
		left Join Localidade			Org on CD_Org_HIA=Org.cd_local
		left Join Localidade			Dst on cd_dst_HIA=DSt.cd_local
		left join Localidade			Por_Org on cd_org_HIA = Por_Org.cd_local
		Left Join Terminal				TERM on LLP.Cd_Terminal = TERM.Cd_Terminal
		Left Join PO_HIA				DI on DI.Num_Proc_HIA=hou.num_proc_HIA and DI.id_dc=5
		left join PO_HIA				DTA on DTA.Num_Proc_HIA = HOU.Num_Proc_HIA and DTA.ID_DC=45
		Join Pessoa_LLP					PLL on PLL.Cd_Pes=HOU.Cd_Consig_HIA and PLL.Cd_Pes_Grupo=@Cd_Grupo
		Left Join Usuario_Cliente		UC on UC.cd_usuario=isnull(PD.PO_Responsible, PD.cd_csrid) and UC.Cd_Cliente=@Cd_Grupo
		Join Pessoa						CSN on CSN.cd_pes=HOU.Cd_Consig_HIA
		left Join Fatura_CHB			FCHB on HOU.Num_Proc_HIA = FCHB.Processo_PC or HOU.Num_Proc_MIA = FCHB.Processo_PC
		Join Pessoa						PP on PP.cd_pes=cd_export_HIA
		Left join janela_processos		JP1 on JP1.Num_Proc = HOU.Num_Proc_HIA and JP1.ID_Janela = '1'
		Left join janela_processos		JP2 on JP2.Num_Proc = HOU.Num_Proc_HIA and JP2.ID_Janela = '2'
		Left join janela_processos		JP3 on JP3.Num_Proc = HOU.Num_Proc_HIA and JP3.ID_Janela = '3'
		left join proc_ncm				NCM on NCM.Num_Proc = hou.num_proc_HIA
--		left join de_para_produto		DPP on PC.Cd_Proc_Cliente = DPP.GMID
		left join Pessoa				BU on PD.CD_Buyer = BU.Cd_Pes
		left join Pessoa				AR on AR.cd_pes = JOB.Cd_agente
		Left Join Hist_Geral			CNL on num_proc_LIA=CNL.hsgprocesso and cd_tp_ocor='28'

	where
		CNL.hsgprocesso is null
		and (dbo.fBusca_Tarefa(hou.num_proc_hia,13) is null) --(dbo.fBusca_Tarefa(hou.num_proc_hia,13) > '2009-12-01' or

	group by
--		PDET.Item,	
		UC.nome_usuario,
		HOU.Num_Proc_HIA,
		HOU.HAWB_HIA,HOU.MAWB_HIA,
		CSN.Apelido,
		CSN.Num_CPF_CNPJ,
		Org.Nome_Local,
		Org.Pais_local,
		Dst.Nome_Local,
		Nome_Cia_Aer,
		Voo_HIA,
		TERM.Nome_Terminal,
		ETD_LIA,
		ATD_LIA,
		ETA_LIA,
		ATA_LIA,
		DI.Numero_PO_HIA, 
		DI.Data_PO_HIA,
		Canal_LIA,	
		dt_emis_HIA,
		PP.Nome_Raz_Soc,
--		TC.Nome_tp_carga,
		HOU.Vol_Tot_HIA,
		PD.Vlr_Pedido,
		JP1.DataInicio,
		JP1.DataFinal,
		JP2.DataInicio,
		JP2.DataFinal,
		JP3.DataInicio,
		JP3.DataFinal,
--		PC.cd_proc_Cliente,
--		PC.Produto_Descr,
--		PCHB.Tipo_LI,
--		PCHB.Import_License,
		PD.Incoterm,
		HOU.Peso_Real_HIA,
--		PC.NCM_Cliente,
--		DPP.Value_Center_Descr,
		BU.Nome_Raz_Soc,
		PD.cd_tp_moeda,
		HOU.cd_tp_moeda,
		HOU.Vlr_Frete_efet_HIA,
		DTA.Data_PO_HIA,
		HOU.Obs_HIA,
--		NC.Paridade,
		AR.Nome_Raz_Soc,
		PD.cd_tp_moeda,
		PD.Cd_Pais_Org,
		Por_Org.Nome_Local,
		HOU.Num_proc_HIA

	order by 
		PO













GO
