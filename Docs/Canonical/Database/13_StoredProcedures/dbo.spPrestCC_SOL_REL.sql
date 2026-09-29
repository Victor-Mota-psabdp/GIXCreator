SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--cadu, removed option 10/04/2023
CREATE Procedure [dbo].[spPrestCC_SOL_REL] -- [dbo].[spPrestCC_SOL_REL]'IASOL201805003BRA','S'
		@Fatura_PC varchar(17),
		@Tipo	Varchar(1),
		@fatcod varchar(17)

as

	Declare @Cd_Pes Varchar(10)	
	Set @CD_PES=(select cd_pes_Grupo from grupo where grupo=substring(@Fatura_PC,3,3))
	
--IF @TIPO='S' or @TIPO='F'
	BEGIN		
		if (len(@Fatura_PC) = 17 or len(@fatura_pc)=16)
			BEGIN
---IMPORTAÇÃO
				SELECT distinct
					(CASE WHEN TT.Ref_Ctb_Tx = 'ADT' then '5' else
						(Case when ITM.TP_PGTO = 'C'  then '1' else
							(Case when (SOL.ID IS not NULL or TT.NF = 'N') and TT.Cd_AX_Repasse not IN ('000.1')   then '2'  else
								(case when TT.Cd_AX_Repasse IN ('000.1')  then '3' else
									'4' END)END)END)END) SEQ,
					isnull(Ordem,99) Order_By,				
					FAT.Data_PC,F.FatDtVenc,FAT.Obs_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ ,
					FAT.FATURA_PC Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,
					RUA,Numero,	Cidade,	UF,					
					Org.Nome_Local Origem, 
					dst.Nome_Local Destino,
					dbo.fBusca_PRODUTO_Produto_Descr(HOU.num_proc) Produto_Descr,
					dbo.fBusca_Docs_PO_Modal(HOU.num_proc,9) Customer_PO,
					dbo.fBusca_DATA_PO_Modal(HOU.num_proc,9) Customer_PO_Data,
					(case when left(HOU.num_proc,2) = 'IM' then 'Maritimo' 
					else  
						(case when left(HOU.num_proc,2) = 'IA' then 'Aereo'
					else
						(case when left(HOU.num_proc,2) = 'IO' then 'Outros'  
						end)end)end)				Modal,
					HOU.HAWB						Conhecimento,
					HOU.ATD							Conhecimento_Data,
					dbo.fBusca_Docs_PO_Modal(HOU.num_proc,2) Invoice,
					dbo.fBusca_DATA_PO_Modal(HOU.num_proc,2) Invoice_Data,
					HOU.Vlr_invoice					Valor_Invoice,
					HOU.Moeda_invoice				Valor_Invoice_MOEDA,
					--[dbo].[fBusca_Custo_Processo_FMC] (HOU.num_proc,'FOB CHARGES') Valor_FOB,
					CAST([dbo].[fBusca_CampoCliente](HOU.num_proc,181)as float) Valor_FOB,
					CAST([dbo].[fBusca_CampoCliente](HOU.num_proc,110)as float) Valor_CIF,
					dbo.fBusca_Docs_PO_Modal(HOU.num_proc,5) DI,
					dbo.fBusca_DATA_PO_Modal(HOU.num_proc,5) DI_Data,
					CONVERT(DECIMAL(18,4),[dbo].[fBusca_CampoCliente](HOU.num_proc,31)) Taxa_Cambial_DI,
					--(select CONVERT(VARCHAR(10),max(Num_NF_HIA)) from vwcta_Cte where Num_Proc_HIA = HOU.num_proc) Nota_Fiscal,
					dbo.fBusca_Docs_PO_Modal_COALESCE(HOU.num_proc,10) Nota_Fiscal,
					dbo.fBusca_DATA_PO_Modal(HOU.num_proc,10) Nota_Fiscal_Data,
					HOU.ATA						Chegada,
					T4.Dt_Conclusao				Desembaraco,
					T165.Dt_Conclusao			Docs_Transporte, --DOCS RETIRADOS PELA TRANSP.
						
					ITM.CD_TP_TX,
					NOME_TP_TX,
					VLR_PC, 
					(CASE WHEN TT.Ref_Ctb_Tx = 'ADT' then 'A' else
						(Case when ITM.TP_PGTO = 'C'     then 'C' else
							(Case when (SOL.ID IS not NULL or TT.NF = 'N') and TT.Cd_AX_Repasse not IN ('000.1')  then 'S' else
								(case when TT.Cd_AX_Repasse IN ('000.1')  then 'R' else
									'D' END)END)END)END) TP_PGTO,
					FAT.Obs_PC OBS_HOU,
					SOL.ID,
				[dbo].[fNCM](HOU.num_proc)		NCM,
				Pais.Nome_Pais					Pais_Origem,
				HOU.Vessel						Navio,
				[dbo].[fBusca_Containers](HOU.num_proc) Containers,
				TT.NF,	
				--TC.Nome_Tp_Carga
				HOU.Cd_Tp_Oper
				FROM 
				--vwFaturasValidasCHB FAT with(nolock)
					FATURA_CHB FAT with(nolock)
					JOIN FATURA_CHB_ITEM ITM with(nolock) ON ITM.FATURA_CC=FAT.FATURA_PC					
					Left Join Fatura F with(nolock) on F.FatCod=FAT.FATURA_PC
					JOIN PESSOA PP with(nolock) ON PP.CD_PES=FAT.CD_PES_PC 
					LEFT Join Endereco ED with(nolock) on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
					LEFT JOIN vwHouse_Imp HOU with(nolock) ON HOU.num_proc=LEFT(FAT.FATURA_PC,16)
					LEFT JOIN vwcta_Cte CCH with(nolock) on CCH.Num_Proc_HIA = LEFT(FAT.FATURA_PC,16) and CCH.Num_NF_HIA is not null AND CCH.Ref_Acesso_NF_HIA <> 'P' AND CCH.Ref_Acesso_NF_HIA is not null and cch.cd_tp_tx = itm.Cd_Tp_Tx
					join Tipo_Taxa TT with(nolock) on TT.cd_tp_Tx=ITM.cd_tp_Tx
					Join Localidade Org with(nolock) on Org.cd_local=HOU.cd_org
					Join Localidade DST with(nolock) on dst.cd_local=HOU.cd_dst
					Left Join Campo_Processo CP with(nolock) on CP.Num_Proc=left(FAT.FATURA_PC,16) and Id_Campo=25
					Left Join Localidade LDE with(nolock) on LDE.cd_local=CP.Campo_Dados
					left join Tarefas_Processos T4 	with(nolock) on T4.Num_Proc = LEFT(FAT.FATURA_PC,16) AND T4.ID_Task = 4
					left join Tarefas_Processos T165 with(nolock) on T165.Num_Proc = LEFT(FAT.FATURA_PC,16) AND T165.ID_Task = 165
					left join vwSolPgtoCtaCteAprovadas SOL with(nolock) on SOL.Num_Proc = LEFT(iTM.Fatura_CC,16) and SOL.Cd_Tp_Tx = ITM.cd_tp_tx and sol.DC = ITM.DC
					Left Join Tipo_Taxa_PC_CHB TCHB with(nolock) on TCHB.cd_tp_tx=TT.cd_tp_tx and cd_pes_grupo=@CD_PES
					left join Pedido_ship PS with(nolock) on PS.Num_Proc = LEFT(FAT.FATURA_PC,16)
					left join Pedido P with(nolock) on P.cd_pedido = PS.cd_pedido
					left join Pais Pais with(nolock) on P.Cd_Pais_Org = Pais.Cd_Pais
					--left join Tipo_Carga TC with(nolock) on HOU.Tp_Carga = TC.Cd_Tp_Carga
				WHERE 
					FAT.FATURA_PC=@Fatura_PC and ITM.Imprime='S'
union all
				SELECT distinct
					'2' SEQ,
					isnull(Ordem,99) Order_By,				
					FAT.Data_PC,F.FatDtVenc,FAT.Obs_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ ,
					FAT.FATURA_PC Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,
					RUA,Numero,	Cidade,	UF,					
					Org.Nome_Local Origem, 
					dst.Nome_Local Destino,
					dbo.fBusca_PRODUTO_Produto_Descr(HOU.num_proc) Produto_Descr,
					dbo.fBusca_Docs_PO_Modal(HOU.num_proc,9) Customer_PO,
					dbo.fBusca_DATA_PO_Modal(HOU.num_proc,9) Customer_PO_Data,
					(case when left(HOU.num_proc,2) = 'IM' then 'Maritimo' 
					else  
						(case when left(HOU.num_proc,2) = 'IA' then 'Aereo'
					else
						(case when left(HOU.num_proc,2) = 'IO' then 'Outros'  
						end)end)end)				Modal,
					HOU.HAWB						Conhecimento,
					HOU.ATD							Conhecimento_Data,
					dbo.fBusca_Docs_PO_Modal(HOU.num_proc,2) Invoice,
					dbo.fBusca_DATA_PO_Modal(HOU.num_proc,2) Invoice_Data,
					HOU.Vlr_invoice					Valor_Invoice,
					HOU.Moeda_invoice				Valor_Invoice_MOEDA,
					--[dbo].[fBusca_Custo_Processo_FMC] (HOU.num_proc,'FOB CHARGES') Valor_FOB,
					CAST([dbo].[fBusca_CampoCliente](HOU.num_proc,181)as float) Valor_FOB,
					CAST([dbo].[fBusca_CampoCliente](HOU.num_proc,110)as float) Valor_CIF,
					dbo.fBusca_Docs_PO_Modal(HOU.num_proc,5) DI,
					dbo.fBusca_DATA_PO_Modal(HOU.num_proc,5) DI_Data,
					CONVERT(DECIMAL(18,4),[dbo].[fBusca_CampoCliente](HOU.num_proc,31)) Taxa_Cambial_DI,
					--(select CONVERT(VARCHAR(10),max(Num_NF_HIA)) from vwcta_Cte where Num_Proc_HIA = HOU.num_proc) Nota_Fiscal,
					dbo.fBusca_Docs_PO_Modal_COALESCE(HOU.num_proc,10) Nota_Fiscal,
					dbo.fBusca_DATA_PO_Modal(HOU.num_proc,10) Nota_Fiscal_Data,
					HOU.ATA						Chegada,
					T4.Dt_Conclusao				Desembaraco,
					T165.Dt_Conclusao			Docs_Transporte, --DOCS RETIRADOS PELA TRANSP.
						
					IFT.CD_TP_TX,
					NOME_TP_TX + ' ('+ @fatcod + ')' Nome_Tp_Tx,
					IFT.Vlr_RS VLR_PC,
					'S' TP_PGTO, -- cadu: 10/04/2023 - 'C' TP_PGTO,
					FAT.Obs_PC OBS_HOU,
					''ID,
				[dbo].[fNCM](HOU.num_proc)		NCM,
				Pais.Nome_Pais					Pais_Origem,
				HOU.Vessel						Navio,
				[dbo].[fBusca_Containers](HOU.num_proc) Containers,
				TT.NF,
				--TC.Nome_Tp_Carga
				HOU.Cd_Tp_Oper
				FROM 
				--vwFaturasValidasCHB FAT with(nolock)
					FATURA_CHB FAT with(nolock)
					JOIN FATURA_CHB_ITEM ITM with(nolock) ON ITM.FATURA_CC=FAT.FATURA_PC					
					Left Join Fatura F with(nolock) on F.FatCod=FAT.FATURA_PC
					Join Fatura FT with(nolock)on FT.fatcod=@fatcod
					Join Item_Fat IFT with(nolock)on FT.fatcod = IFT.FatCod
					JOIN PESSOA PP with(nolock) ON PP.CD_PES=FAT.CD_PES_PC 
					LEFT Join Endereco ED with(nolock) on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
					LEFT JOIN vwHouse_Imp HOU with(nolock) ON HOU.num_proc=LEFT(FAT.FATURA_PC,16)
					LEFT JOIN vwcta_Cte CCH with(nolock) on CCH.Num_Proc_HIA = LEFT(FAT.FATURA_PC,16) and CCH.Num_NF_HIA is not null AND CCH.Ref_Acesso_NF_HIA <> 'P' AND CCH.Ref_Acesso_NF_HIA is not null and cch.cd_tp_tx = itm.Cd_Tp_Tx
					join Tipo_Taxa TT with(nolock) on TT.cd_tp_Tx=IFT.cd_tp_Tx
					Join Localidade Org with(nolock) on Org.cd_local=HOU.cd_org
					Join Localidade DST with(nolock) on dst.cd_local=HOU.cd_dst
					Left Join Campo_Processo CP with(nolock) on CP.Num_Proc=left(FAT.FATURA_PC,16) and Id_Campo=25
					Left Join Localidade LDE with(nolock) on LDE.cd_local=CP.Campo_Dados
					left join Tarefas_Processos T4 	with(nolock) on T4.Num_Proc = LEFT(FAT.FATURA_PC,16) AND T4.ID_Task = 4
					left join Tarefas_Processos T165 with(nolock) on T165.Num_Proc = LEFT(FAT.FATURA_PC,16) AND T165.ID_Task = 165
					Left Join Tipo_Taxa_PC_CHB TCHB with(nolock) on TCHB.cd_tp_tx=TT.cd_tp_tx and cd_pes_grupo=@CD_PES
					left join Pedido_ship PS with(nolock) on PS.Num_Proc = LEFT(FAT.FATURA_PC,16)
					left join Pedido P with(nolock) on P.cd_pedido = PS.cd_pedido
					left join Pais Pais with(nolock) on P.Cd_Pais_Org = Pais.Cd_Pais
					--left join Tipo_Carga TC with(nolock) on HOU.Tp_Carga = TC.Cd_Tp_Carga
				WHERE 
					FAT.FATURA_PC=@Fatura_PC 
					union ALL			
---EXPORTAÇÃO
				SELECT distinct
					(CASE WHEN TT.Ref_Ctb_Tx = 'ADT' then '5' else
						(Case when ITM.TP_PGTO = 'C'  then '1' else
							(Case when (SOL.ID IS not NULL or TT.NF = 'N') and TT.Cd_AX_Repasse not IN ('000.1')   then '2'  else
								(case when TT.Cd_AX_Repasse IN ('000.1')  then '3' else
									'4' END)END)END)END) SEQ,
					isnull(Ordem,99) Order_By,				
					FAT.Data_PC,F.FatDtVenc,FAT.Obs_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ ,
					FAT.FATURA_PC Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,
					RUA,Numero,	Cidade,	UF,					
					Org.Nome_Local Origem, 
					dst.Nome_Local Destino,
					dbo.fBusca_PRODUTO_Produto_Descr(HOU.num_proc) Produto_Descr,
					dbo.fBusca_Docs_PO_Modal(HOU.num_proc,9) Customer_PO,
					dbo.fBusca_DATA_PO_Modal(HOU.num_proc,9) Customer_PO_Data,
					(case when left(HOU.num_proc,2) = 'EM' then 'Maritimo' 
					else  
						(case when left(HOU.num_proc,2) = 'EA' then 'Aereo'
					else
						(case when left(HOU.num_proc,2) = 'EO' then 'Outros'  
						end)end)end)				Modal,
					HOU.MAWB						Conhecimento,
					HOU.ATD							Conhecimento_Data,
					dbo.fBusca_Docs_PO_Modal(HOU.num_proc,2) Invoice,
					dbo.fBusca_DATA_PO_Modal(HOU.num_proc,2) Invoice_Data,
					HOU.Vlr_invoice					Valor_Invoice,
					HOU.Moeda_invoice				Valor_Invoice_MOEDA,
					--[dbo].[fBusca_Custo_Processo_FMC] (HOU.num_proc,'FOB CHARGES') Valor_FOB,
					CAST([dbo].[fBusca_CampoCliente](HOU.num_proc,181)as float) Valor_FOB,
					CAST([dbo].[fBusca_CampoCliente](HOU.num_proc,110)as float) Valor_CIF,
					(case when dbo.fBusca_Docs_PO_Modal(HOU.num_proc,4) is null then dbo.fBusca_Docs_PO_Modal(HOU.num_proc,204) else dbo.fBusca_Docs_PO_Modal(HOU.num_proc,4) End ) DI,
					(case when dbo.fBusca_DATA_PO_Modal(HOU.num_proc,4) is null then dbo.fBusca_DATA_PO_Modal(HOU.num_proc,204) else dbo.fBusca_DATA_PO_Modal(HOU.num_proc,4) End ) DI_Data,
					CONVERT(DECIMAL(18,4),[dbo].[fBusca_CampoCliente](HOU.num_proc,31)) Taxa_Cambial_DI,
					--(select CONVERT(VARCHAR(10),max(Num_NF_HIA)) from vwcta_Cte where Num_Proc_HIA = HOU.num_proc) Nota_Fiscal,
					dbo.fBusca_Docs_PO_Modal_COALESCE(HOU.num_proc,10) Nota_Fiscal,
					dbo.fBusca_DATA_PO_Modal(HOU.num_proc,10) Nota_Fiscal_Data,
					HOU.ATA						Chegada,
					T4.Dt_Conclusao				Desembaraco,
					T165.Dt_Conclusao			Docs_Transporte, --DOCS RETIRADOS PELA TRANSP.
						
					ITM.CD_TP_TX,
					NOME_TP_TX,
					VLR_PC, 
					(CASE WHEN TT.Ref_Ctb_Tx = 'ADT' then 'A' else
						(Case when ITM.TP_PGTO = 'C'     then 'C' else
							(Case when (SOL.ID IS not NULL or TT.NF = 'N') and TT.Cd_AX_Repasse not IN ('000.1')  then 'S' else
								(case when TT.Cd_AX_Repasse IN ('000.1')  then 'R' else
									'D' END)END)END)END) TP_PGTO,
					FAT.Obs_PC OBS_HOU,
					SOL.ID,
				[dbo].[fNCM](HOU.num_proc)		NCM,
				Pais.Nome_Pais					Pais_Origem,
				HOU.Vessel						Navio,
				[dbo].[fBusca_Containers](HOU.num_proc) Containers,
				TT.NF,
				--TC.Nome_Tp_Carga
				HOU.Cd_Tp_Oper
				FROM 
				--vwFaturasValidasCHB FAT with(nolock)
					FATURA_CHB FAT with(nolock)
					JOIN FATURA_CHB_ITEM ITM with(nolock) ON ITM.FATURA_CC=FAT.FATURA_PC					
					Left Join Fatura F with(nolock) on F.FatCod=FAT.FATURA_PC
					JOIN PESSOA PP with(nolock) ON PP.CD_PES=FAT.CD_PES_PC 
					LEFT Join Endereco ED with(nolock) on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
					LEFT JOIN vwHouse_Exp HOU with(nolock) ON HOU.num_proc=LEFT(FAT.FATURA_PC,16)
					LEFT JOIN vwcta_Cte CCH with(nolock) on CCH.Num_Proc_HIA = LEFT(FAT.FATURA_PC,16) and CCH.Num_NF_HIA is not null AND CCH.Ref_Acesso_NF_HIA <> 'P' AND CCH.Ref_Acesso_NF_HIA is not null and cch.cd_tp_tx = itm.Cd_Tp_Tx
					join Tipo_Taxa TT with(nolock) on TT.cd_tp_Tx=ITM.cd_tp_Tx
					Join Localidade Org with(nolock) on Org.cd_local=HOU.cd_org
					Join Localidade DST with(nolock) on dst.cd_local=HOU.cd_dst
					Left Join Campo_Processo CP with(nolock) on CP.Num_Proc=left(FAT.FATURA_PC,16) and Id_Campo=25
					Left Join Localidade LDE with(nolock) on LDE.cd_local=CP.Campo_Dados
					left join Tarefas_Processos T4 	with(nolock) on T4.Num_Proc = LEFT(FAT.FATURA_PC,16) AND T4.ID_Task = 4
					left join Tarefas_Processos T165 with(nolock) on T165.Num_Proc = LEFT(FAT.FATURA_PC,16) AND T165.ID_Task = 165
					left join vwSolPgtoCtaCteAprovadas SOL with(nolock) on SOL.Num_Proc = LEFT(iTM.Fatura_CC,16) and SOL.Cd_Tp_Tx = ITM.cd_tp_tx and sol.DC = ITM.DC
					Left Join Tipo_Taxa_PC_CHB TCHB with(nolock) on TCHB.cd_tp_tx=TT.cd_tp_tx and cd_pes_grupo=@CD_PES
					left join Pedido_ship PS with(nolock) on PS.Num_Proc = LEFT(FAT.FATURA_PC,16)
					left join Pedido P with(nolock) on P.cd_pedido = PS.cd_pedido
					left join Pais Pais with(nolock) on P.Cd_Pais_Org = Pais.Cd_Pais
					--left join Tipo_Carga TC with(nolock) on HOU.CD_Tp_Carga = TC.Cd_Tp_Carga
				WHERE 
					FAT.FATURA_PC=@Fatura_PC and ITM.Imprime='S'
union all
				SELECT distinct
					'2' SEQ,
					isnull(Ordem,99) Order_By,				
					FAT.Data_PC,F.FatDtVenc,FAT.Obs_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ ,
					FAT.FATURA_PC Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,
					RUA,Numero,	Cidade,	UF,					
					Org.Nome_Local Origem, 
					dst.Nome_Local Destino,
					dbo.fBusca_PRODUTO_Produto_Descr(HOU.num_proc) Produto_Descr,
					dbo.fBusca_Docs_PO_Modal(HOU.num_proc,9) Customer_PO,
					dbo.fBusca_DATA_PO_Modal(HOU.num_proc,9) Customer_PO_Data,
					(case when left(HOU.num_proc,2) = 'EM' then 'Maritimo' 
					else  
						(case when left(HOU.num_proc,2) = 'EA' then 'Aereo'
					else
						(case when left(HOU.num_proc,2) = 'EO' then 'Outros'  
						end)end)end)				Modal,
					HOU.HAWB						Conhecimento,
					HOU.ATD							Conhecimento_Data,
					dbo.fBusca_Docs_PO_Modal(HOU.num_proc,2) Invoice,
					dbo.fBusca_DATA_PO_Modal(HOU.num_proc,2) Invoice_Data,
					HOU.Vlr_invoice					Valor_Invoice,
					HOU.Moeda_invoice				Valor_Invoice_MOEDA,
					--[dbo].[fBusca_Custo_Processo_FMC] (HOU.num_proc,'FOB CHARGES') Valor_FOB,
					CAST([dbo].[fBusca_CampoCliente](HOU.num_proc,181)as float) Valor_FOB,
					CAST([dbo].[fBusca_CampoCliente](HOU.num_proc,110)as float) Valor_CIF,
					(case when dbo.fBusca_Docs_PO_Modal(HOU.num_proc,4) is null then dbo.fBusca_Docs_PO_Modal(HOU.num_proc,204) else dbo.fBusca_Docs_PO_Modal(HOU.num_proc,4) End ) DI,
					(case when dbo.fBusca_DATA_PO_Modal(HOU.num_proc,4) is null then dbo.fBusca_DATA_PO_Modal(HOU.num_proc,204) else dbo.fBusca_DATA_PO_Modal(HOU.num_proc,4) End ) DI_Data,
					CONVERT(DECIMAL(18,4),[dbo].[fBusca_CampoCliente](HOU.num_proc,31)) Taxa_Cambial_DI,
					--(select CONVERT(VARCHAR(10),max(Num_NF_HIA)) from vwcta_Cte where Num_Proc_HIA = HOU.num_proc) Nota_Fiscal,
					dbo.fBusca_Docs_PO_Modal_COALESCE(HOU.num_proc,10) Nota_Fiscal,
					dbo.fBusca_DATA_PO_Modal(HOU.num_proc,10) Nota_Fiscal_Data,
					HOU.ATA						Chegada,
					T4.Dt_Conclusao				Desembaraco,
					T165.Dt_Conclusao			Docs_Transporte, --DOCS RETIRADOS PELA TRANSP.
						
					IFT.CD_TP_TX,
					NOME_TP_TX + ' ('+ @fatcod + ')' Nome_Tp_Tx,
					IFT.Vlr_RS VLR_PC,
					'S' TP_PGTO, -- cadu: 10/04/2023 - 'C' TP_PGTO,
					FAT.Obs_PC OBS_HOU,
					''ID,
				[dbo].[fNCM](HOU.num_proc)		NCM,
				Pais.Nome_Pais					Pais_Origem,
				HOU.Vessel						Navio,
				[dbo].[fBusca_Containers](HOU.num_proc) Containers,
				TT.NF,
				--TC.Nome_Tp_Carga
				HOU.Cd_Tp_Oper
				FROM 
				--vwFaturasValidasCHB FAT with(nolock)
					FATURA_CHB FAT with(nolock)
					JOIN FATURA_CHB_ITEM ITM with(nolock) ON ITM.FATURA_CC=FAT.FATURA_PC					
					Left Join Fatura F with(nolock) on F.FatCod=FAT.FATURA_PC
					Join Fatura FT with(nolock)on FT.fatcod=@fatcod
					Join Item_Fat IFT with(nolock)on FT.fatcod = IFT.FatCod
					JOIN PESSOA PP with(nolock) ON PP.CD_PES=FAT.CD_PES_PC 
					LEFT Join Endereco ED with(nolock) on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
					LEFT JOIN vwHouse_Exp HOU with(nolock) ON HOU.num_proc=LEFT(FAT.FATURA_PC,16)
					LEFT JOIN vwcta_Cte CCH with(nolock) on CCH.Num_Proc_HIA = LEFT(FAT.FATURA_PC,16) and CCH.Num_NF_HIA is not null AND CCH.Ref_Acesso_NF_HIA <> 'P' AND CCH.Ref_Acesso_NF_HIA is not null and cch.cd_tp_tx = itm.Cd_Tp_Tx
					join Tipo_Taxa TT with(nolock) on TT.cd_tp_Tx=IFT.cd_tp_Tx
					Join Localidade Org with(nolock) on Org.cd_local=HOU.cd_org
					Join Localidade DST with(nolock) on dst.cd_local=HOU.cd_dst
					Left Join Campo_Processo CP with(nolock) on CP.Num_Proc=left(FAT.FATURA_PC,16) and Id_Campo=25
					Left Join Localidade LDE with(nolock) on LDE.cd_local=CP.Campo_Dados
					left join Tarefas_Processos T4 	with(nolock) on T4.Num_Proc = LEFT(FAT.FATURA_PC,16) AND T4.ID_Task = 4
					left join Tarefas_Processos T165 with(nolock) on T165.Num_Proc = LEFT(FAT.FATURA_PC,16) AND T165.ID_Task = 165
					Left Join Tipo_Taxa_PC_CHB TCHB with(nolock) on TCHB.cd_tp_tx=TT.cd_tp_tx and cd_pes_grupo=@CD_PES
					left join Pedido_ship PS with(nolock) on PS.Num_Proc = LEFT(FAT.FATURA_PC,16)
					left join Pedido P with(nolock) on P.cd_pedido = PS.cd_pedido
					left join Pais Pais with(nolock) on P.Cd_Pais_Org = Pais.Cd_Pais
					--left join Tipo_Carga TC with(nolock) on HOU.CD_Tp_Carga = TC.Cd_Tp_Carga
				WHERE 
					FAT.FATURA_PC=@Fatura_PC 						
			ORDER BY 1,2
		END
			
	END
--ELSE
--	BEGIN		
--		if (len(@Fatura_PC) = 17 or len(@fatura_pc)=16)
--			BEGIN
--				SELECT distinct
--					(CASE WHEN TT.Ref_Ctb_Tx = 'ADT' then '5' else
--						(Case when ITM.TP_PGTO = 'C'  then '1' else
--							(Case when (SOL.ID IS not NULL or TT.NF = 'N') and TT.Cd_AX_Repasse not IN ('000.1')   then '2'  else
--								(case when TT.Cd_AX_Repasse IN ('000.1')  then '3' else
--									'4' END)END)END)END) SEQ,
--					isnull(Ordem,99) Order_By,				
--					FAT.Data_PC,F.FatDtVenc,FAT.Obs_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ ,
--					FAT.FATURA_PC Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,
--					RUA,Numero,	Cidade,	UF,					
--					Org.Nome_Local Origem, 
--					dst.Nome_Local Destino,
--					dbo.fBusca_PRODUTO_Produto_Descr(HOU.num_proc) Produto_Descr,
--					dbo.fBusca_Docs_PO_Modal(HOU.num_proc,9) Customer_PO,
--					dbo.fBusca_DATA_PO_Modal(HOU.num_proc,9) Customer_PO_Data,
--					(case when left(HOU.num_proc,2) = 'IM' then 'Maritimo' 
--					else  
--						(case when left(HOU.num_proc,2) = 'IA' then 'Aereo'
--					else
--						(case when left(HOU.num_proc,2) = 'IO' then 'Outros'  
--						end)end)end)				Modal,
--					HOU.HAWB						Conhecimento,
--					HOU.ATD							Conhecimento_Data,
--					dbo.fBusca_Docs_PO_Modal(HOU.num_proc,2) Invoice,
--					dbo.fBusca_DATA_PO_Modal(HOU.num_proc,2) Invoice_Data,
--					HOU.Vlr_invoice					Valor_Invoice,
--					HOU.Moeda_invoice				Valor_Invoice_MOEDA,
--					--[dbo].[fBusca_Custo_Processo_FMC] (HOU.num_proc,'FOB CHARGES') Valor_FOB,
--					CAST([dbo].[fBusca_CampoCliente](HOU.num_proc,181)as float) Valor_FOB,
--					CAST([dbo].[fBusca_CampoCliente](HOU.num_proc,110)as float) Valor_CIF,
--					dbo.fBusca_Docs_PO_Modal(HOU.num_proc,5) DI,
--					dbo.fBusca_DATA_PO_Modal(HOU.num_proc,5) DI_Data,
--					CONVERT(DECIMAL(18,4),[dbo].[fBusca_CampoCliente](HOU.num_proc,31)) Taxa_Cambial_DI,
--					--(select CONVERT(VARCHAR(10),max(Num_NF_HIA)) from vwcta_Cte where Num_Proc_HIA = HOU.num_proc) Nota_Fiscal,
--					dbo.fBusca_Docs_PO_Modal_COALESCE(HOU.num_proc,10) Nota_Fiscal,
--					dbo.fBusca_DATA_PO_Modal(HOU.num_proc,10) Nota_Fiscal_Data,
--					HOU.ATA						Chegada,
--					T4.Dt_Conclusao				Desembaraco,
--					T165.Dt_Conclusao			Docs_Transporte, --DOCS RETIRADOS PELA TRANSP.
						
--					ITM.CD_TP_TX,
--					NOME_TP_TX,
--					VLR_PC, 
--					(CASE WHEN TT.Ref_Ctb_Tx = 'ADT' then 'A' else
--						(Case when ITM.TP_PGTO = 'C'     then 'C' else
--							(Case when (SOL.ID IS not NULL or TT.NF = 'N') and TT.Cd_AX_Repasse not IN ('000.1')  then 'S' else
--								(case when TT.Cd_AX_Repasse IN ('000.1')  then 'R' else
--									'D' END)END)END)END) TP_PGTO,
--					FAT.Obs_PC OBS_HOU,
--					SOL.ID,
--				[dbo].[fNCM](HOU.num_proc)		NCM,
--				Pais.Nome_Pais					Pais_Origem,
--				HOU.Vessel						Navio,
--				[dbo].[fBusca_Containers](HOU.num_proc) Containers,
--					TT.NF,
--					---TC.Nome_Tp_Carga	
--					HOU.Cd_Tp_Oper				
--				FROM 
--					FATURA_CHB FAT with(nolock)
--					JOIN FATURA_CHB_ITEM ITM with(nolock) ON ITM.FATURA_CC=FAT.FATURA_PC
--					Left Join Fatura F with(nolock) on F.FatCod=FAT.Fatura_PC
--					JOIN PESSOA PP with(nolock) ON PP.CD_PES=FAT.CD_PES_PC 
--					LEFT Join Endereco ED with(nolock) on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
--					LEFT JOIN vwHouse_Imp HOU with(nolock) ON HOU.num_proc=LEFT(FAT.Fatura_PC,16)
--					LEFT JOIN vwcta_Cte CCH with(nolock) on CCH.Num_Proc_HIA = LEFT(FAT.Fatura_PC,16) and CCH.Num_NF_HIA is not null AND CCH.Ref_Acesso_NF_HIA <> 'P' AND CCH.Ref_Acesso_NF_HIA is not null and cch.cd_tp_tx = itm.Cd_Tp_Tx
--					join Tipo_Taxa TT with(nolock) on TT.cd_tp_Tx=itm.cd_tp_Tx
--					Join Localidade Org with(nolock) on Org.cd_local=HOU.cd_org
--					Join Localidade DST with(nolock) on dst.cd_local=HOU.cd_dst
--					Left Join Campo_Processo CP with(nolock) on CP.Num_Proc=left(FAT.Fatura_PC,16) and Id_Campo=25
--					Left Join Localidade LDE with(nolock) on LDE.cd_local=CP.Campo_Dados
--					left join Tarefas_Processos T4 	with(nolock) on T4.Num_Proc = LEFT(FAT.Fatura_PC,16) AND T4.ID_Task = 4
--					left join Tarefas_Processos T165 with(nolock) on T165.Num_Proc = LEFT(FAT.Fatura_PC,16) AND T165.ID_Task = 165
--					left join vwSolPgtoCtaCteAprovadas SOL with(nolock) on SOL.Num_Proc = ITM.Fatura_CC and SOL.Cd_Tp_Tx = ITM.cd_tp_tx and sol.DC = ITM.DC
--					Left Join Tipo_Taxa_PC_CHB TCHB with(nolock) on TCHB.cd_tp_tx=TT.cd_tp_tx and cd_pes_grupo=@Cd_Pes
--					left join Pedido_ship PS with(nolock) on PS.Num_Proc = LEFT(FAT.Fatura_PC,16)
--					left join Pedido P with(nolock) on P.cd_pedido = PS.cd_pedido
--					left join Pais Pais with(nolock) on P.Cd_Pais_Org = Pais.Cd_Pais
--					--left join Tipo_Carga TC with(nolock) on HOU.Tp_Carga = TC.Cd_Tp_Carga
--				WHERE 
--					FAT.Fatura_PC=@Fatura_PC	
							
--			ORDER BY 1,2
--		END
			
--	END


GO
