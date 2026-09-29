SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--1º Impostos
--2º Repasse pagamento BDP
--3º Descrição de serviços
--4º Adiantamento
--select * from Tipo_Taxa_PC_CHB where CD_Pes_Grupo ='P000030340' order by Ordem
--select * from Grupo where grupo=substring('IMSOL201802001BRA',3,3)

--P000030340
--insert into Tipo_Taxa_PC_CHB
--select'P000030340',Modal,Cd_Tp_Tx, Descricao,6 from Tipo_Taxa_PC_CHB where cd_tp_tx =  'XAC' and CD_Pes_Grupo ='P21130'
--select'P000030340',Modal,Cd_Tp_Tx, 'Taxas Siscomex',5 from Tipo_Taxa_PC_CHB where cd_tp_tx =  'XAD' and CD_Pes_Grupo ='P21130'
--select'P000030340',Modal,Cd_Tp_Tx, Descricao,4 from Tipo_Taxa_PC_CHB where cd_tp_tx =  'XAP' and CD_Pes_Grupo ='P21130'
--select'P000030340',Modal,Cd_Tp_Tx, Descricao,3 from Tipo_Taxa_PC_CHB where cd_tp_tx =  'XAO' and CD_Pes_Grupo ='P21130'
--select'P000030340',Modal,Cd_Tp_Tx, Descricao,Ordem from Tipo_Taxa_PC_CHB where cd_tp_tx =  'XAB' and CD_Pes_Grupo ='P21130'
--select'P000030340',Modal,Cd_Tp_Tx, Descricao,Ordem from Tipo_Taxa_PC_CHB where cd_tp_tx =  'XAA' and CD_Pes_Grupo ='P21130'	
--[dbo].[spPrestCC_SOL_REL]'IMSOL201804001BR','S'
--[dbo].[spPrestCC_SOL_REL]'IMSOL201803001BRA','S'
CREATE Procedure [dbo].[spPrestCC_SOL_REL_17-09-2018] -- [dbo].[spPrestCC_SOL_REL]'IASOL201805003BRA','S'
		@Fatura_PC varchar(17),
		@Tipo	Varchar(1)

as

	Declare @Cd_Pes Varchar(10)	
	Set @CD_PES=(select cd_pes_Grupo from grupo where grupo=substring(@Fatura_PC,3,3))
	
IF @TIPO='S'
	BEGIN		
		if (len(@Fatura_PC) = 17 or len(@fatura_pc)=16)
			BEGIN
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
				TT.NF	
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
				WHERE 
					FAT.FATURA_PC=@Fatura_PC and ITM.Imprime='S'						
			ORDER BY 1,2
		END
			
	END
ELSE
	BEGIN		
		if (len(@Fatura_PC) = 17 or len(@fatura_pc)=16)
			BEGIN
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
					TT.NF					
				FROM 
					FATURA_CHB FAT with(nolock)
					JOIN FATURA_CHB_ITEM ITM with(nolock) ON ITM.FATURA_CC=FAT.FATURA_PC
					Left Join Fatura F with(nolock) on F.FatCod=FAT.Fatura_PC
					JOIN PESSOA PP with(nolock) ON PP.CD_PES=FAT.CD_PES_PC 
					LEFT Join Endereco ED with(nolock) on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
					LEFT JOIN vwHouse_Imp HOU with(nolock) ON HOU.num_proc=LEFT(FAT.Fatura_PC,16)
					LEFT JOIN vwcta_Cte CCH with(nolock) on CCH.Num_Proc_HIA = LEFT(FAT.Fatura_PC,16) and CCH.Num_NF_HIA is not null AND CCH.Ref_Acesso_NF_HIA <> 'P' AND CCH.Ref_Acesso_NF_HIA is not null and cch.cd_tp_tx = itm.Cd_Tp_Tx
					join Tipo_Taxa TT with(nolock) on TT.cd_tp_Tx=itm.cd_tp_Tx
					Join Localidade Org with(nolock) on Org.cd_local=HOU.cd_org
					Join Localidade DST with(nolock) on dst.cd_local=HOU.cd_dst
					Left Join Campo_Processo CP with(nolock) on CP.Num_Proc=left(FAT.Fatura_PC,16) and Id_Campo=25
					Left Join Localidade LDE with(nolock) on LDE.cd_local=CP.Campo_Dados
					left join Tarefas_Processos T4 	with(nolock) on T4.Num_Proc = LEFT(FAT.Fatura_PC,16) AND T4.ID_Task = 4
					left join Tarefas_Processos T165 with(nolock) on T165.Num_Proc = LEFT(FAT.Fatura_PC,16) AND T165.ID_Task = 165
					left join vwSolPgtoCtaCteAprovadas SOL with(nolock) on SOL.Num_Proc = ITM.Fatura_CC and SOL.Cd_Tp_Tx = ITM.cd_tp_tx and sol.DC = ITM.DC
					Left Join Tipo_Taxa_PC_CHB TCHB with(nolock) on TCHB.cd_tp_tx=TT.cd_tp_tx and cd_pes_grupo=@Cd_Pes
					left join Pedido_ship PS with(nolock) on PS.Num_Proc = LEFT(FAT.Fatura_PC,16)
					left join Pedido P with(nolock) on P.cd_pedido = PS.cd_pedido
					left join Pais Pais with(nolock) on P.Cd_Pais_Org = Pais.Cd_Pais
				WHERE 
					FAT.Fatura_PC=@Fatura_PC	
							
			ORDER BY 1,2
		END
			
	END













































GO
