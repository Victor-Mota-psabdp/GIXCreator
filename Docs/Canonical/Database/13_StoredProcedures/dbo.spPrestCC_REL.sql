SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spPrestCC_REL] 
		@Fatura_PC varchar(17),
		@Tipo	Varchar(1),
		@fatcod varchar(17)

as
/* -------------------------------------------------------------------------------------------------------------------------
HISTORY CHANGE
. Date: 04/09/2019
. Applicant: CSR Sherwin Williams (Rosangela)
. Developer: Alessandra Suzuki Mariano
. Request:	Ticket change requested 100-155779 as
		Trata-se de customização da capa da prestação de contas para atender necessidade do cliente em implementação.
		. Disponibilizar esta melhoria a todos os clientes.
		. Inclusão do Shipper na prestação de contas
. Date 14/04/2023 
. Include number of Num_Proc_HBO Job start with BO, when used print an atl choose type <> "S" 
  has error return proc field not found as result 
-------------------------------------------------------------------------------------------------------------------------
EXECUTION EXECUTION
exec  [dbo].[spPrestCC_REL]'BOSOL201807032BR','S',''
-------------------------------------------------------------------------------------------------------------------------

04/09/2019 - Ticket 100-155779
*/  


SET NOCOUNT ON
IF @TIPO='S'
	BEGIN
		
		if left(@fatura_pc,2)='BO' and (len(@Fatura_PC) = 17 or len(@fatura_pc)=16)
		BEGIN
		
--			--Transportation
--		SELECT 
--				Distinct
--				Data_PC,F.fatDtVenc,OBS_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ ,Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,
--				RUA,Numero,Cidade,UF,max(Numero_PO_HBO) Referencia_Cliente,DI_RE_PC,'' Origem, 
--				'' Destino,'' House,IFT.CD_TP_TX,NOME_TP_TX + ' ('+ @fatcod + ')' NOME_TP_TX,
--				IFT.Vlr_RS VLR_PC, 'B' TP_PGTO, FAT.Obs_PC OBS_HOU, 
--				CNS.Nome_Raz_Soc CNS, LDE.Nome_Local Local_Desemb,
--				dbo.fBusca_Tarefa(HOU.Num_Proc_HBO,4) Dt_Desembaraco,
----				fatDtVenc Vencimento,
--				max(CCH.num_nf_HBO) num_nf,				 
--				max(isnull(CCH.ref_acesso_nf_HBO,'')) [Site],
--				Repasse_TX  
--			FROM 
--				FATURA_CHB FAT with(nolock)
--				JOIN FATURA_CHB_ITEM ITM with(nolock) ON ITM.FATURA_CC=FAT.FATURA_PC
--				Join Fatura FT with(nolock)on FT.fatcod=@fatcod
--				Join Item_Fat IFT with(nolock)on FT.fatcod = IFT.FatCod
--				JOIN PESSOA PP with(nolock) ON PP.CD_PES=CD_PES_PC
--				LEFT Join Endereco ED with(nolock) on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
--				LEFT JOIN House_BDP_OUT HOU with(nolock) ON HOU.NUM_PROC_HBO=LEFT(FATURA_PC,16)
--				JOIN Cta_Cte_HOU_BDP_OUT CCH with(nolock) on CCH.num_proc_HBO = LEFT(FATURA_PC,16)  and cch.cd_tp_tx = IFT.cd_tp_tx
--				join Tipo_Taxa TT with(nolock) on TT.cd_tp_Tx=IFT.cd_tp_Tx
--				LEft Join PO_HBO PO with(nolock) on lefT(fat.fatura_pc,16)=po.num_proC_HBO AND ID_DC = 1
--				--Join Localidade Org with(nolock) on Org.cd_local=cd_org_HBO
--				--Join Localidade dst with(nolock) on dst.cd_local=cd_dst_HBO
--				left join Pessoa CNS with(nolock) on CNS.cd_pes = HOU.cd_cliente_HBO
--				Left Join Campo_Processo CP with(nolock) on CP.Num_Proc=left(FATURA_PC,16) and Id_Campo=25
--				Left Join Localidade LDE with(nolock) on LDE.cd_local=CP.Campo_Dados
--				Left Join Fatura F with(nolock)on F.fatcod=fatura_pc

--			WHERE 
--				FATURA_PC=@Fatura_PC
--			group by 
--				HOU.Num_Proc_HBO, Data_pc,F.fatDtVenc,Obs_Pc,FAT.Obs_PC,right(PP.Num_CPF_CNPJ,14),Fatura_PC,PP.Apelido,
--				PP.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,IFT.CD_TP_TX,NOME_TP_TX,IFT.Vlr_RS, TP_PGTO, 
--				CNS.Nome_Raz_Soc, LDE.Nome_Local,Repasse_TX
--			union all	
		
			SELECT 
				Distinct
				Data_PC,fatDtVenc,Obs_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ ,Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,
				RUA,Numero,Cidade,UF,max(Numero_PO_HBO) Referencia_Cliente,DI_RE_PC,'' Origem, 
				'' Destino,'' House,ITM.CD_TP_TX, 
				CASE
				WHEN cast(DP.Cd_Dst as varchar(100)) is null then TT.Nome_Tp_Tx
				else 
				cast(DP.Cd_Dst as varchar(100)) 
				end as NOME_TP_TX, -- Kaique 18/12/2025 - Ticket 100-538694
				VLR_PC, TP_PGTO, FAT.Obs_PC OBS_HOU, 
				CNS.Nome_Raz_Soc CNS, LDE.Nome_Local Local_Desemb,
				dbo.fBusca_Tarefa(HOU.Num_Proc_HBO,4) Dt_Desembaraco,
--				Data_PC,fatDtVenc Vencimento, 
				Max(CCH.Num_NF_HBO) num_nf,				
				Max(isnull(CCH.Ref_Acesso_NF_HBO,'')) [Site],
				Repasse_TX 
				,[dbo].[fBusca_Docs_PO_Modal](LEFT(FATURA_PC,16),19) Num_Proc_HBO
				,p2.Nome_Raz_Soc as [Shipper] -- Alessandra 04/09/2019 - Ticket 100-155779
			FROM 
				FATURA_CHB FAT with(nolock)
				JOIN FATURA_CHB_ITEM ITM with(nolock) ON ITM.FATURA_CC=FAT.FATURA_PC
				JOIN PESSOA PP with(nolock) ON PP.CD_PES=CD_PES_PC
				JOIN Pessoa_LLP PLLP ON PP.Cd_Pes = PLLP.Cd_Pes -- - Kaique 18/12/2025 - Ticket 100-538694
				LEFT Join Endereco ED with(nolock) on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
				LEFT JOIN House_BDP_OUT HOU with(nolock) ON HOU.Num_Proc_HBO=LEFT(FATURA_PC,16)
				LEFT JOIN Cta_Cte_HOU_BDP_OUT CCH with(nolock) on CCH.Num_Proc_HBO = LEFT(FATURA_PC,16) and CCH.Num_NF_HBO is not null AND CCH.Ref_Acesso_NF_HBO <> 'P' AND CCH.Ref_Acesso_NF_HBO is not null and cch.cd_tp_tx = ITM.cd_tp_tx
				join Tipo_Taxa TT with(nolock) on TT.cd_tp_Tx=itm.cd_tp_Tx
				LEft Join PO_HBO PO with(nolock) on lefT(fat.fatura_pc,16)=po.Num_Proc_HBO AND ID_DC = 1
				--Join Localidade Org with(nolock) on Org.cd_local=cd_org_HEO
				--Join Localidade dst with(nolock) on dst.cd_local=cd_dst_HEO
				left join Pessoa CNS with(nolock) on CNS.cd_pes = HOU.cd_cliente_HBO
				Left Join Campo_Processo CP with(nolock) on CP.Num_Proc=left(@Fatura_PC,16) and Id_Campo=25
				Left Join Localidade LDE with(nolock) on LDE.cd_local=CP.Campo_Dados
				Left Join Fatura with(nolock) on fatcod=fatura_pc
				left join vwClienteALLJOBS vv with(nolock) on vv.num_proc=processo_pc -- Alessandra 04/09/2019 - Ticket 100-155779
				left join Pessoa p2 with(nolock) on  vv.cd_fornecedor = p2.cd_pes -- Alessandra 04/09/2019 - Ticket 100-155779
				left join DE_PARA DP with(nolock) on DP.Cd_Org = TT.Cd_Tp_Tx and DP.Cd_Cliente = PLLP.Cd_Pes_Grupo and DP.Cd_Tipo = 38-- -- Kaique 18/12/2025 - Ticket 100-538694
			WHERE 
				FATURA_PC=@FATURA_PC and imprime='S'
			group by 
				HOU.Num_Proc_HBO, Data_pc,fatDtVenc,Obs_Pc,FAT.Obs_PC,right(PP.Num_CPF_CNPJ,14),Fatura_PC,PP.Apelido,
				PP.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,ITM.CD_TP_TX,NOME_TP_TX,DP.Cd_Dst,VLR_PC, TP_PGTO, 
				CNS.Nome_Raz_Soc, LDE.Nome_Local,Repasse_TX,p2.Nome_Raz_Soc  -- Alessandra 04/09/2019 - Ticket 100-155779
		END

	    if left(@fatura_pc,2)='EO' and (len(@Fatura_PC) = 17 or len(@fatura_pc)=16)
		BEGIN
			--Transportation
		SELECT 
				Distinct
				Data_PC,F.fatDtVenc,OBS_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ ,Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,
				RUA,Numero,Cidade,UF,max(Numero_PO_HEO) Referencia_Cliente,DI_RE_PC,org.nome_local Origem, 
				dst.nome_local Destino,hawb_HEO House,IFT.CD_TP_TX, CASE
				WHEN cast(DP.Cd_Dst as varchar(100)) is null then TT.Nome_Tp_Tx + ' ('+ @fatcod + ')'
				else 
				cast(DP.Cd_Dst as varchar(100)) + ' ('+ @fatcod + ')' 
				end as NOME_TP_TX, -- Kaique 18/12/2025 - Ticket 100-538694
				IFT.Vlr_RS VLR_PC, 'B' TP_PGTO, Obs_HEO OBS_HOU, 
				CNS.Nome_Raz_Soc CNS, LDE.Nome_Local Local_Desemb,
				dbo.fBusca_Tarefa(HOU.Num_Proc_HEO,4) Dt_Desembaraco,
--				fatDtVenc Vencimento,
				max(CCH.num_nf_HEO) num_nf,				 
				max(isnull(CCH.ref_acesso_nf_HEO,'')) [Site],
				Repasse_TX  
				,p2.Nome_Raz_Soc as [Shipper] -- Alessandra 04/09/2019 - Ticket 100-155779
			FROM 
				FATURA_CHB FAT with(nolock)
				JOIN FATURA_CHB_ITEM ITM with(nolock) ON ITM.FATURA_CC=FAT.FATURA_PC
				Join Fatura FT with(nolock)on FT.fatcod=@fatcod
				Join Item_Fat IFT with(nolock)on FT.fatcod = IFT.FatCod
				JOIN PESSOA PP with(nolock) ON PP.CD_PES=CD_PES_PC
				JOIN Pessoa_LLP PLLP ON PP.Cd_Pes = PLLP.Cd_Pes -- - Kaique 18/12/2025 - Ticket 100-538694
				LEFT Join Endereco ED with(nolock) on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
				LEFT JOIN HOUSE_EXP_OUT HOU with(nolock) ON HOU.NUM_PROC_HEO=LEFT(FATURA_PC,16)
				JOIN cta_cte_hou_EXP_OUT CCH with(nolock) on CCH.num_proc_HEO = LEFT(FATURA_PC,16)  and cch.cd_tp_tx = IFT.cd_tp_tx
				join Tipo_Taxa TT with(nolock) on TT.cd_tp_Tx=IFT.cd_tp_Tx
				LEft Join PO_HEO PO with(nolock) on lefT(fat.fatura_pc,16)=po.num_proC_HEO AND ID_DC = 1
				Join Localidade Org with(nolock) on Org.cd_local=cd_org_HEO
				Join Localidade dst with(nolock) on dst.cd_local=cd_dst_HEO
				left join Pessoa CNS with(nolock) on CNS.cd_pes = HOU.cd_consig_HEO
				Left Join Campo_Processo CP with(nolock) on CP.Num_Proc=left(FATURA_PC,16) and Id_Campo=25
				Left Join Localidade LDE with(nolock) on LDE.cd_local=CP.Campo_Dados
				Left Join Fatura F with(nolock)on F.fatcod=fatura_pc
				left join vwClienteALLJOBS vv with(nolock) on vv.num_proc=processo_pc -- Alessandra 04/09/2019 - Ticket 100-155779
				left join Pessoa p2 with(nolock) on  vv.cd_fornecedor = p2.cd_pes -- Alessandra 04/09/2019 - Ticket 100-155779
				left join DE_PARA DP with(nolock) on DP.Cd_Org = TT.Cd_Tp_Tx and DP.Cd_Cliente = PLLP.Cd_Pes_Grupo and DP.Cd_Tipo = 38-- -- Kaique 18/12/2025 - Ticket 100-538694

			WHERE 
				FATURA_PC=@Fatura_PC
			group by 
				HOU.Num_Proc_HEO,Data_PC,F.fatDtVenc,Obs_PC,obs_HEO,right(pp.Num_CPF_CNPJ,14),Fatura_PC,pp.Apelido,
				pp.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,hawb_HEO ,IFT.CD_TP_TX,
				DP.Cd_Dst,NOME_TP_TX,IFT.Vlr_RS, CNS.Nome_Raz_Soc, LDE.Nome_Local,Repasse_TX,p2.Nome_Raz_Soc  -- Alessandra 04/09/2019 - Ticket 100-155779
			union all
			SELECT 
				Distinct
				Data_PC,fatDtVenc,Obs_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ ,Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,
				RUA,Numero,Cidade,UF,max(Numero_PO_HEO) Referencia_Cliente,DI_RE_PC,org.nome_local Origem, 
				dst.nome_local Destino,hawb_HEO House,ITM.CD_TP_TX,
				CASE
				WHEN cast(DP.Cd_Dst as varchar(100)) is null then TT.Nome_Tp_Tx
				else 
				cast(DP.Cd_Dst as varchar(100)) 
				end as NOME_TP_TX, -- Kaique 18/12/2025 - Ticket 100-538694
				VLR_PC, TP_PGTO, Obs_heo OBS_HOU, 
				CNS.Nome_Raz_Soc CNS, LDE.Nome_Local Local_Desemb,
				dbo.fBusca_Tarefa(HOU.Num_Proc_HEO,4) Dt_Desembaraco,
--				Data_PC,fatDtVenc Vencimento, 
				Max(CCH.num_nf_heo) num_nf,				
				Max(isnull(CCH.ref_acesso_nf_heo,'')) [Site],
				Repasse_TX 
				,p2.Nome_Raz_Soc as [Shipper] -- Alessandra 04/09/2019 - Ticket 100-155779
			FROM 
				FATURA_CHB FAT with(nolock)
				JOIN FATURA_CHB_ITEM ITM with(nolock) ON ITM.FATURA_CC=FAT.FATURA_PC
				JOIN PESSOA PP with(nolock) ON PP.CD_PES=CD_PES_PC
				JOIN Pessoa_LLP PLLP ON PP.Cd_Pes = PLLP.Cd_Pes -- - Kaique 18/12/2025 - Ticket 100-538694
				LEFT Join Endereco ED with(nolock) on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
				LEFT JOIN HOUSE_EXP_OUT HOU with(nolock) ON HOU.NUM_PROC_HEO=LEFT(FATURA_PC,16)
				LEFT JOIN cta_cte_hou_exp_out CCH with(nolock) on CCH.num_proc_heo = LEFT(FATURA_PC,16) and CCH.num_nf_heo is not null AND CCH.REF_ACESSO_NF_Heo <> 'P' AND CCH.REF_ACESSO_NF_Heo is not null and cch.cd_tp_tx = ITM.cd_tp_tx
				join Tipo_Taxa TT with(nolock) on TT.cd_tp_Tx=itm.cd_tp_Tx
				LEft Join PO_HEO PO with(nolock) on lefT(fat.fatura_pc,16)=po.num_proC_HEO AND ID_DC = 1
				Join Localidade Org with(nolock) on Org.cd_local=cd_org_HEO
				Join Localidade dst with(nolock) on dst.cd_local=cd_dst_HEO
				left join Pessoa CNS with(nolock) on CNS.cd_pes = HOU.cd_export_HEO
				Left Join Campo_Processo CP with(nolock) on CP.Num_Proc=left(@Fatura_PC,16) and Id_Campo=25
				Left Join Localidade LDE with(nolock) on LDE.cd_local=CP.Campo_Dados
				Left Join Fatura with(nolock) on fatcod=fatura_pc
				left join vwClienteALLJOBS vv with(nolock) on vv.num_proc=processo_pc -- Alessandra 04/09/2019 - Ticket 100-155779
				left join Pessoa p2 with(nolock) on  vv.cd_fornecedor = p2.cd_pes -- Alessandra 04/09/2019 - Ticket 100-155779
				left join DE_PARA DP with(nolock) on DP.Cd_Org = TT.Cd_Tp_Tx and DP.Cd_Cliente = PLLP.Cd_Pes_Grupo and DP.Cd_Tipo = 38-- -- Kaique 18/12/2025 - Ticket 100-538694
			WHERE 
				FATURA_PC=@FATURA_PC and imprime='S'
			group by 
				HOU.Num_Proc_HEO, Data_pc,fatDtVenc,Obs_Pc,Obs_Heo,right(PP.Num_CPF_CNPJ,14),Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,
				RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,hawb_HEO ,ITM.CD_TP_TX,DP.cd_dst,NOME_TP_TX,VLR_PC, TP_PGTO, 
				CNS.Nome_Raz_Soc, LDE.Nome_Local,Repasse_TX,p2.Nome_Raz_Soc  -- Alessandra 04/09/2019 - Ticket 100-155779
		END

	    if left(@fatura_pc,2)='IO' and (len(@Fatura_PC) = 17 or len(@fatura_pc)=16)
		BEGIN
			--Transportation
		SELECT 
				Distinct
				Data_PC,F.fatDtVenc,OBS_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ ,Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,
				RUA,Numero,Cidade,UF,max(Numero_PO_HIO) Referencia_Cliente,DI_RE_PC,org.nome_local Origem, 
				dst.nome_local Destino,hawb_HIO House,IFT.CD_TP_TX,
				Case
				WHEN cast(DP.Cd_Dst as varchar(100)) is null then TT.Nome_Tp_Tx + ' ('+ @fatcod + ')'
				else 
				cast(DP.Cd_Dst as varchar(100)) + ' ('+ @fatcod + ')' 
				end as NOME_TP_TX, -- Kaique 18/12/2025 - Ticket 100-538694
				IFT.Vlr_RS VLR_PC, 'B' TP_PGTO, Obs_HIO OBS_HOU, 
				CNS.Nome_Raz_Soc CNS, LDE.Nome_Local Local_Desemb,
				dbo.fBusca_Tarefa(HOU.Num_Proc_HIO,4) Dt_Desembaraco,
--				fatDtVenc Vencimento,
				max(CCH.num_nf_HIO) num_nf,				 
				max(isnull(CCH.ref_acesso_nf_HIO,'')) [Site],
				Repasse_TX  
				,p2.Nome_Raz_Soc as [Shipper] -- Alessandra 04/09/2019 - Ticket 100-155779
			FROM 
				FATURA_CHB FAT with(nolock)
				JOIN FATURA_CHB_ITEM ITM with(nolock) ON ITM.FATURA_CC=FAT.FATURA_PC
				Join Fatura FT with(nolock)on FT.fatcod=@fatcod
				Join Item_Fat IFT with(nolock)on FT.fatcod = IFT.FatCod
				JOIN PESSOA PP with(nolock) ON PP.CD_PES=CD_PES_PC
				JOIN Pessoa_LLP PLLP ON PP.Cd_Pes = PLLP.Cd_Pes -- - Kaique 18/12/2025 - Ticket 100-538694
				LEFT Join Endereco ED with(nolock) on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
				LEFT JOIN HOUSE_IMP_OUT HOU with(nolock) ON HOU.NUM_PROC_HIO=LEFT(FATURA_PC,16)
				JOIN cta_cte_hou_IMP_OUT CCH with(nolock) on CCH.num_proc_HIO = LEFT(FATURA_PC,16)  and cch.cd_tp_tx = IFT.cd_tp_tx
				join Tipo_Taxa TT with(nolock) on TT.cd_tp_Tx=IFT.cd_tp_Tx
				LEft Join PO_HIO PO with(nolock) on lefT(fat.fatura_pc,16)=po.num_proC_HIO AND ID_DC = 1
				Join Localidade Org with(nolock) on Org.cd_local=cd_org_HIO
				Join Localidade dst with(nolock) on dst.cd_local=cd_dst_HIO
				left join Pessoa CNS with(nolock) on CNS.cd_pes = HOU.cd_consig_HIO
				Left Join Campo_Processo CP with(nolock) on CP.Num_Proc=left(FATURA_PC,16) and Id_Campo=25
				Left Join Localidade LDE with(nolock) on LDE.cd_local=CP.Campo_Dados
				Left Join Fatura F with(nolock)on F.fatcod=fatura_pc
				left join vwClienteALLJOBS vv with(nolock) on vv.num_proc=processo_pc -- Alessandra 04/09/2019 - Ticket 100-155779
				left join Pessoa p2 with(nolock) on  vv.cd_fornecedor = p2.cd_pes -- Alessandra 04/09/2019 - Ticket 100-155779
				left join DE_PARA DP with(nolock) on DP.Cd_Org = TT.Cd_Tp_Tx and DP.Cd_Cliente = PLLP.Cd_Pes_Grupo and DP.Cd_Tipo = 38-- -- Kaique 18/12/2025 - Ticket 100-538694

			WHERE 
				FATURA_PC=@Fatura_PC
			group by 
				HOU.Num_Proc_HIO,Data_PC,F.fatDtVenc,Obs_PC,obs_HIO,right(pp.Num_CPF_CNPJ,14),Fatura_PC,pp.Apelido,
				pp.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,hawb_HIO ,IFT.CD_TP_TX,
				DP.cd_dst,NOME_TP_TX,IFT.Vlr_RS, CNS.Nome_Raz_Soc, LDE.Nome_Local,Repasse_TX,p2.Nome_Raz_Soc  -- Alessandra 04/09/2019 - Ticket 100-155779
			union all
			SELECT 
				Distinct
					Data_PC,fatDtVenc,obs_pc OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ, Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,
					RUA,Numero,Cidade,UF,max(Numero_PO_HIO) Referencia_Cliente,DI_RE_PC,org.nome_local Origem, 
					dst.nome_local Destino,hawb_HIO House,ITM.CD_TP_TX,
					CASE
					WHEN cast(DP.Cd_Dst as varchar(100)) is null then TT.Nome_Tp_Tx
					else 
					cast(DP.Cd_Dst as varchar(100))
					end as NOME_TP_TX, -- Kaique 18/12/2025 - Ticket 100-538694
					VLR_PC, TP_PGTO, Obs_hio OBS_HOU, 
					CNS.Nome_Raz_soc CNS, LDE.Nome_Local Local_Desemb,
					dbo.fBusca_Tarefa(HOU.Num_Proc_HIO,4) Dt_Desembaraco, 
--					Data_PC, fatDtVenc Vencimento, 
					max(CCH.num_nf_hio) num_nf,					
					max(isnull(CCH.ref_acesso_nf_hio,'')) [Site],
					Repasse_TX 
					,p2.Nome_Raz_Soc as [Shipper] -- Alessandra 04/09/2019 - Ticket 100-155779
			FROM 
				FATURA_CHB FAT with(nolock)
				JOIN FATURA_CHB_ITEM ITM with(nolock) ON ITM.FATURA_CC=FAT.FATURA_PC
				JOIN PESSOA PP with(nolock) ON PP.CD_PES=CD_PES_PC
				JOIN Pessoa_LLP PLLP ON PP.Cd_Pes = PLLP.Cd_Pes -- - Kaique 18/12/2025 - Ticket 100-538694
				LEFT Join Endereco ED with(nolock) on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
				LEFT JOIN HOUSE_IMP_OUT HOU with(nolock) ON HOU.NUM_PROC_HIO=LEFT(FATURA_PC,16)
				LEFT JOIN cta_cte_hou_imp_out CCH with(nolock) on CCH.num_proc_hio = LEFT(FATURA_PC,16) and CCH.num_nf_hio is not null AND CCH.REF_ACESSO_NF_HIo <> 'P' AND CCH.REF_ACESSO_NF_Hio is not null and cch.cd_tp_tx = ITM.cd_tp_tx
				left join Tipo_Taxa TT with(nolock) on TT.cd_tp_Tx=itm.cd_tp_Tx
				LEft Join PO_HIO PO with(nolock) on lefT(fat.fatura_pc,16)=po.num_proC_HIO AND ID_DC = 1
				left Join Localidade Org with(nolock) on Org.cd_local=cd_org_HIO
				left  Join Localidade dst with(nolock) on dst.cd_local=cd_dst_HIO
				left join Pessoa CNS with(nolock) on CNS.cd_pes = HOU.cd_consig_HIO
				Left Join Campo_Processo CP with(nolock) on CP.Num_Proc=left(@Fatura_PC,16) and Id_Campo=25
				Left Join Localidade LDE with(nolock) on LDE.cd_local=CP.Campo_Dados
				Left Join Fatura with(nolock) on fatcod=fatura_pc
				left join vwClienteALLJOBS vv with(nolock) on vv.num_proc=processo_pc -- Alessandra 04/09/2019 - Ticket 100-155779
				left join Pessoa p2 with(nolock) on  vv.cd_fornecedor = p2.cd_pes -- Alessandra 04/09/2019 - Ticket 100-155779
				left join DE_PARA DP with(nolock) on DP.Cd_Org = TT.Cd_Tp_Tx and DP.Cd_Cliente = PLLP.Cd_Pes_Grupo and DP.Cd_Tipo = 38-- -- Kaique 18/12/2025 - Ticket 100-538694

			WHERE 
				FATURA_PC=@FATURA_PC and imprime='S'
			group by 
				HOU.Num_Proc_HIO,Data_PC,fatDtVenc,Obs_PC,obs_hio,right(PP.Num_CPF_CNPJ,14),Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,hawb_HIO ,ITM.CD_TP_TX,DP.Cd_dst,NOME_TP_TX,VLR_PC, TP_PGTO, CNS.Nome_Raz_Soc, LDE.Nome_Local
				,Repasse_TX,p2.Nome_Raz_Soc  -- Alessandra 04/09/2019 - Ticket 100-155779
		END

	    if left(@fatura_pc,2)='IM' and (len(@Fatura_PC) = 17 or len(@Fatura_PC) = 16)
		BEGIN
		Print 'Sim'
--			--Transportation
--		SELECT 
--				Distinct
--				Data_PC,F.fatDtVenc,OBS_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ ,Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,
--				RUA,Numero,Cidade,UF,max(Numero_PO_HIM) Referencia_Cliente,DI_RE_PC,org.nome_local Origem, 
--				dst.nome_local Destino,hawb_him House,IFT.CD_TP_TX,NOME_TP_TX + ' ('+ @fatcod + ')' NOME_TP_TX,
--				IFT.Vlr_RS VLR_PC, 'B' TP_PGTO, Obs_him OBS_HOU, 
--				CNS.Nome_Raz_Soc CNS, LDE.Nome_Local Local_Desemb,
--				dbo.fBusca_Tarefa(HOU.Num_Proc_HIM,4) Dt_Desembaraco,
----				fatDtVenc Vencimento,
--				max(CCH.num_nf_him) num_nf,				 
--				max(isnull(CCH.ref_acesso_nf_him,'')) [Site],
--				Repasse_TX  
--			FROM 
--				FATURA_CHB FAT with(nolock)
--				JOIN FATURA_CHB_ITEM ITM with(nolock) ON ITM.FATURA_CC=FAT.FATURA_PC
--				Join Fatura FT with(nolock)on FT.fatcod=@fatcod
--				Join Item_Fat IFT with(nolock)on FT.fatcod = IFT.FatCod
--				JOIN PESSOA PP with(nolock) ON PP.CD_PES=CD_PES_PC
--				LEFT Join Endereco ED with(nolock) on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
--				LEFT JOIN HOUSE_IMP_MAR HOU with(nolock) ON HOU.NUM_PROC_HIM=LEFT(FATURA_PC,16)
--				JOIN cta_cte_hou_imp_mar CCH with(nolock) on CCH.num_proc_him = LEFT(FATURA_PC,16)  and cch.cd_tp_tx = IFT.cd_tp_tx
--				join Tipo_Taxa TT with(nolock) on TT.cd_tp_Tx=IFT.cd_tp_Tx
--				LEft Join PO_HIM PO with(nolock) on lefT(fat.fatura_pc,16)=po.num_proC_him AND ID_DC = 1
--				Join Localidade Org with(nolock) on Org.cd_local=cd_org_him
--				Join Localidade dst with(nolock) on dst.cd_local=cd_dst_him
--				left join Pessoa CNS with(nolock) on CNS.cd_pes = HOU.cd_consig_HIM
--				Left Join Campo_Processo CP with(nolock) on CP.Num_Proc=left(FATURA_PC,16) and Id_Campo=25
--				Left Join Localidade LDE with(nolock) on LDE.cd_local=CP.Campo_Dados
--				Left Join Fatura F with(nolock)on F.fatcod=fatura_pc

--			WHERE 
--				FATURA_PC=@Fatura_PC
--			group by 
--				HOU.Num_Proc_HIM,Data_PC,F.fatDtVenc,Obs_PC,obs_him,right(pp.Num_CPF_CNPJ,14),Fatura_PC,pp.Apelido,
--				pp.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,hawb_him ,IFT.CD_TP_TX,
--				NOME_TP_TX,IFT.Vlr_RS, CNS.Nome_Raz_Soc, LDE.Nome_Local,Repasse_TX
--			union all
		
			SELECT 
				Distinct
				Data_PC,fatDtVenc,OBS_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ ,Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,
				RUA,Numero,Cidade,UF,max(Numero_PO_HIM) Referencia_Cliente,DI_RE_PC,org.nome_local Origem, 
				dst.nome_local Destino,hawb_him House,ITM.CD_TP_TX,
				CASE
				WHEN cast(DP.Cd_Dst as varchar(100)) is null then TT.Nome_Tp_Tx
				else 
				cast(DP.Cd_Dst as varchar(100)) 
				end as NOME_TP_TX, -- Kaique 18/12/2025 - Ticket 100-538694
				VLR_PC, TP_PGTO, Obs_him OBS_HOU, 
				CNS.Nome_Raz_Soc CNS, LDE.Nome_Local Local_Desemb,
				dbo.fBusca_Tarefa(HOU.Num_Proc_HIM,4) Dt_Desembaraco,
--				fatDtVenc Vencimento,
				max(CCH.num_nf_him) num_nf,				 
				max(isnull(CCH.ref_acesso_nf_him,'')) [Site],
				Repasse_TX  
				,p2.Nome_Raz_Soc as [Shipper] -- Alessandra 04/09/2019 - Ticket 100-155779
			FROM 
				FATURA_CHB FAT with(nolock)
				JOIN FATURA_CHB_ITEM ITM with(nolock) ON ITM.FATURA_CC=FAT.FATURA_PC
				JOIN PESSOA PP with(nolock) ON PP.CD_PES=CD_PES_PC 
				JOIN Pessoa_LLP PLLP ON PP.Cd_Pes = PLLP.Cd_Pes
				LEFT Join Endereco ED with(nolock) on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
				LEFT JOIN HOUSE_IMP_MAR HOU with(nolock) ON HOU.NUM_PROC_HIM=LEFT(FATURA_PC,16)
				LEFT JOIN cta_cte_hou_imp_mar CCH with(nolock) on CCH.num_proc_him = LEFT(FATURA_PC,16) and CCH.num_nf_him is not null AND CCH.REF_ACESSO_NF_HIM <> 'P' AND CCH.REF_ACESSO_NF_Him is not null and cch.cd_tp_tx = ITM.cd_tp_tx
				join Tipo_Taxa TT with(nolock) on TT.cd_tp_Tx=itm.cd_tp_Tx
				LEft Join PO_HIM PO with(nolock) on lefT(fat.fatura_pc,16)=po.num_proC_him AND ID_DC = 1
				Join Localidade Org with(nolock) on Org.cd_local=cd_org_him
				Join Localidade dst with(nolock) on dst.cd_local=cd_dst_him
				left join Pessoa CNS with(nolock) on CNS.cd_pes = HOU.cd_consig_HIM
				Left Join Campo_Processo CP with(nolock) on CP.Num_Proc=left(@Fatura_PC,16) and Id_Campo=25
				Left Join Localidade LDE with(nolock) on LDE.cd_local=CP.Campo_Dados
				Left Join Fatura with(nolock)on fatcod=fatura_pc
				left join vwClienteALLJOBS vv with(nolock) on vv.num_proc=processo_pc -- Alessandra 04/09/2019 - Ticket 100-155779
				left join Pessoa p2 with(nolock) on  vv.cd_fornecedor = p2.cd_pes -- Alessandra 04/09/2019 - Ticket 100-155779
				left join DE_PARA DP with(nolock) on DP.Cd_Org = TT.Cd_Tp_Tx and DP.Cd_Cliente = PLLP.Cd_Pes_Grupo and DP.Cd_Tipo = 38-- -- Kaique 18/12/2025 - Ticket 100-538694
 
			WHERE 
				FATURA_PC=@Fatura_PC and imprime='S'
			group by 
				HOU.Num_Proc_HIM,Data_PC,fatDtVenc,Obs_PC,obs_him,right(pp.Num_CPF_CNPJ,14),Fatura_PC,pp.Apelido,pp.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,hawb_him ,ITM.CD_TP_TX,DP.cd_dst,NOME_TP_TX,VLR_PC, TP_PGTO, CNS.Nome_Raz_Soc, LDE.Nome_Local
				,Repasse_TX,p2.Nome_Raz_Soc  -- Kaique 18/12/2025 - Ticket 100-538694

		
	END
		
		IF left(@fatura_pc,2)='IA' and (len(@Fatura_PC) = 17 or len(@fatura_pc)=16)
			BEGIN
	--Transportation
		SELECT 
				Distinct
				Data_PC,F.fatDtVenc,OBS_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ ,Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,
				RUA,Numero,Cidade,UF,max(Numero_PO_HIA) Referencia_Cliente,DI_RE_PC,org.nome_local Origem, 
				dst.nome_local Destino,hawb_HIA House, IFT.CD_TP_TX,
				CASE
				WHEN
				cast(DP.Cd_Dst as varchar(100)) is null then NOME_TP_TX + ' ('+ @fatcod + ')'
				else 
				cast(DP.Cd_Dst as varchar(100)) + ' ('+ @fatcod + ')' end
				as NOME_TP_TX,
				IFT.Vlr_RS VLR_PC, 'B' TP_PGTO, Obs_HIA OBS_HOU, 
				CNS.Nome_Raz_Soc CNS, LDE.Nome_Local Local_Desemb,
				dbo.fBusca_Tarefa(HOU.Num_Proc_HIA,4) Dt_Desembaraco,
--				fatDtVenc Vencimento,
				max(CCH.num_nf_HIA) num_nf,				 
				max(isnull(CCH.ref_acesso_nf_HIA,'')) [Site],
				Repasse_TX  
				,p2.Nome_Raz_Soc as [Shipper] -- Alessandra 04/09/2019 - Ticket 100-155779
			FROM 
				FATURA_CHB FAT with(nolock)
				JOIN FATURA_CHB_ITEM ITM with(nolock) ON ITM.FATURA_CC=FAT.FATURA_PC
				Join Fatura FT with(nolock)on FT.fatcod=@fatcod
				Join Item_Fat IFT with(nolock)on FT.fatcod = IFT.FatCod
				JOIN PESSOA PP with(nolock) ON PP.CD_PES=CD_PES_PC
				JOIN Pessoa_LLP PLLP ON PP.Cd_Pes = PLLP.Cd_Pes
				LEFT Join Endereco ED with(nolock) on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
				LEFT JOIN HOUSE_IMP_AER HOU with(nolock) ON HOU.NUM_PROC_HIA=LEFT(FATURA_PC,16)
				JOIN cta_cte_hou_IMP_AER CCH with(nolock) on CCH.num_proc_HIA = LEFT(FATURA_PC,16)  and cch.cd_tp_tx = IFT.cd_tp_tx
				join Tipo_Taxa TT with(nolock) on TT.cd_tp_Tx=IFT.cd_tp_Tx
				LEft Join PO_HIA PO with(nolock) on lefT(fat.fatura_pc,16)=po.num_proC_HIA AND ID_DC = 1
				Join Localidade Org with(nolock) on Org.cd_local=cd_org_HIA
				Join Localidade dst with(nolock) on dst.cd_local=cd_dst_HIA
				left join Pessoa CNS with(nolock) on CNS.cd_pes = HOU.cd_consig_HIA
				Left Join Campo_Processo CP with(nolock) on CP.Num_Proc=left(FATURA_PC,16) and Id_Campo=25
				Left Join Localidade LDE with(nolock) on LDE.cd_local=CP.Campo_Dados
				Left Join Fatura F with(nolock)on F.fatcod=fatura_pc
				left join vwClienteALLJOBS vv with(nolock) on vv.num_proc=processo_pc -- Alessandra 04/09/2019 - Ticket 100-155779
				left join Pessoa p2 with(nolock) on  vv.cd_fornecedor = p2.cd_pes -- Alessandra 04/09/2019 - Ticket 100-155779
				left join DE_PARA DP with(nolock) on DP.Cd_Org = TT.Cd_Tp_Tx and DP.Cd_Cliente = PLLP.Cd_Pes_Grupo and DP.Cd_Tipo = 38-- -- Kaique 18/12/2025 - Ticket 100-538694

			WHERE 
				FATURA_PC=@Fatura_PC
			group by 
				HOU.Num_Proc_HIA,Data_PC,F.fatDtVenc,Obs_PC,obs_HIA,right(pp.Num_CPF_CNPJ,14),Fatura_PC,pp.Apelido,
				pp.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,hawb_HIA ,IFT.CD_TP_TX,
				NOME_TP_TX,DP.cd_dst,IFT.Vlr_RS, CNS.Nome_Raz_Soc, LDE.Nome_Local,Repasse_TX,p2.Nome_Raz_Soc  -- Alessandra 04/09/2019 - Ticket 100-155779
			union all
				SELECT 
					Data_PC,fatDtVenc,Obs_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ, Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,
					RUA,Numero,Cidade,UF, max(Numero_PO_hia) Referencia_Cliente,DI_RE_PC,org.nome_local Origem, 
					dst.nome_local Destino,hawb_hia House,ITM.CD_TP_TX,
					CASE
					WHEN
					cast(DP.Cd_Dst as varchar(100)) is null then NOME_TP_TX
					else 
					cast(DP.Cd_Dst as varchar(100)) end
					as NOME_TP_TX,	
					VLR_PC, TP_PGTO, Obs_hia OBS_HOU, 
					CNS.Nome_Raz_Soc CNS, LDE.Nome_Local Local_Desemb,
					dbo.fBusca_Tarefa(HOU.Num_Proc_HIA,4) Dt_Desembaraco,
--					Data_PC,fatDtVenc Vencimento, 
					Max(cch.num_nf_hia) num_nf,			
					max(isnull(CCH.ref_acesso_nf_hia,'')) [Site],
					Repasse_TX 
					,p2.Nome_Raz_Soc as [Shipper] -- Alessandra 04/09/2019 - Ticket 100-155779
				FROM 
					FATURA_CHB FAT with(nolock)
					JOIN FATURA_CHB_ITEM ITM with(nolock) ON ITM.FATURA_CC=FAT.FATURA_PC
					JOIN PESSOA PP with(nolock) ON PP.CD_PES=CD_PES_PC
					JOIN Pessoa_LLP PLLP ON PP.Cd_Pes = PLLP.Cd_Pes
					LEFT Join Endereco ED with(nolock) on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
					LEFT JOIN HOUSE_IMP_aer HOU with(nolock) ON HOU.NUM_PROC_hia=LEFT(FATURA_PC,16)
					LEFT JOIN cta_cte_hou_imp_aer CCH with(nolock) on CCH.num_proc_hia = LEFT(FATURA_PC,16) and CCH.num_nf_hia is not null AND CCH.REF_ACESSO_NF_HIa <> 'P' AND CCH.REF_ACESSO_NF_Hia is not null and cch.cd_tp_tx = ITM.cd_tp_tx
					join Tipo_Taxa TT with(nolock) on TT.cd_tp_Tx=itm.cd_tp_Tx
					LEft Join PO_hia PO with(nolock) on lefT(fat.fatura_pc,16)=po.num_proC_hia  AND ID_DC = 1
					Join Localidade Org with(nolock)on Org.cd_local=cd_org_hia
					Join Localidade dst with(nolock)on dst.cd_local=cd_dst_hia
					left join Pessoa CNS with(nolock) on CNS.cd_pes = HOU.cd_consig_HIA
					Left Join Campo_Processo CP with(nolock) on CP.Num_Proc=left(@Fatura_PC,16) and Id_Campo=25
					Left Join Localidade LDE with(nolock) on LDE.cd_local=CP.Campo_Dados
					Left Join Fatura with(nolock) on fatcod=fatura_pc
					left join vwClienteALLJOBS vv with(nolock) on vv.num_proc=processo_pc -- Alessandra 04/09/2019 - Ticket 100-155779
					left join Pessoa p2 with(nolock) on  vv.cd_fornecedor = p2.cd_pes -- Alessandra 04/09/2019 - Ticket 100-155779
					left join DE_PARA DP with(nolock) on DP.Cd_Org = TT.Cd_Tp_Tx and DP.Cd_Cliente = PLLP.Cd_Pes_Grupo and DP.Cd_Tipo = 38-- -- Kaique 18/12/2025 - Ticket 100-538694

				WHERE 
					FATURA_PC=@FATURA_PC and imprime='S'
				group by 
					HOU.Num_Proc_HIA,Data_PC,fatDtVenc,obs_PC,obs_hia,right(pp.Num_CPF_CNPJ,14), Fatura_PC,pp.Apelido,pp.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,hawb_hia ,ITM.CD_TP_TX,NOME_TP_TX,DP.cd_dst,VLR_PC, TP_PGTO, CNS.Nome_Raz_Soc, LDE.Nome_Local
					,Repasse_TX,p2.Nome_Raz_Soc  -- Alessandra 04/09/2019 - Ticket 100-155779
			END	
				
		IF left(@fatura_pc,2)='EM' and (len(@Fatura_PC) = 17 or len(@fatura_pc)=16)
			BEGIN
	--Transportation
		SELECT 
				Distinct
				Data_PC,F.fatDtVenc,OBS_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ ,Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,
				RUA,Numero,Cidade,UF,max(Numero_PO_HEM) Referencia_Cliente,DI_RE_PC,org.nome_local Origem, 
				dst.nome_local Destino,hawb_HEM House,IFT.CD_TP_TX,
				CASE
				WHEN cast(DP.Cd_Dst as varchar(100)) is null then NOME_TP_TX + ' ('+ @fatcod + ')' 
				else 
				cast(DP.Cd_Dst as varchar(100)) + ' ('+ @fatcod + ')' 
				end as NOME_TP_TX,
				IFT.Vlr_RS VLR_PC, 'B' TP_PGTO, Obs_HEM OBS_HOU, 
				CNS.Nome_Raz_Soc CNS, LDE.Nome_Local Local_Desemb,
				dbo.fBusca_Tarefa(HOU.Num_Proc_HEM,4) Dt_Desembaraco,
--				fatDtVenc Vencimento,
				max(CCH.num_nf_HEM) num_nf,				 
				max(isnull(CCH.ref_acesso_nf_HEM,'')) [Site],
				Repasse_TX  
				,p2.Nome_Raz_Soc as [Shipper] -- Alessandra 04/09/2019 - Ticket 100-155779
			FROM 
				FATURA_CHB FAT with(nolock)
				JOIN FATURA_CHB_ITEM ITM with(nolock) ON ITM.FATURA_CC=FAT.FATURA_PC
				Join Fatura FT with(nolock)on FT.fatcod=@fatcod
				Join Item_Fat IFT with(nolock)on FT.fatcod = IFT.FatCod
				JOIN PESSOA PP with(nolock) ON PP.CD_PES=CD_PES_PC
				JOIN Pessoa_LLP PLLP ON PP.Cd_Pes = PLLP.Cd_Pes -- - Kaique 18/12/2025 - Ticket 100-538694
				LEFT Join Endereco ED with(nolock) on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
				LEFT JOIN HOUSE_EXP_MAR HOU with(nolock) ON HOU.NUM_PROC_HEM=LEFT(FATURA_PC,16)
				JOIN cta_cte_hou_EXP_MAR CCH with(nolock) on CCH.num_proc_HEM = LEFT(FATURA_PC,16)  and cch.cd_tp_tx = IFT.cd_tp_tx
				join Tipo_Taxa TT with(nolock) on TT.cd_tp_Tx=IFT.cd_tp_Tx
				LEft Join PO_HEM PO with(nolock) on lefT(fat.fatura_pc,16)=po.num_proC_HEM AND ID_DC = 1
				Join Localidade Org with(nolock) on Org.cd_local=cd_org_HEM
				Join Localidade dst with(nolock) on dst.cd_local=cd_dst_HEM
				left join Pessoa CNS with(nolock) on CNS.cd_pes = HOU.cd_consig_HEM
				Left Join Campo_Processo CP with(nolock) on CP.Num_Proc=left(FATURA_PC,16) and Id_Campo=25
				Left Join Localidade LDE with(nolock) on LDE.cd_local=CP.Campo_Dados
				Left Join Fatura F with(nolock)on F.fatcod=fatura_pc
				left join vwClienteALLJOBS vv with(nolock) on vv.num_proc=processo_pc -- Alessandra 04/09/2019 - Ticket 100-155779
				left join Pessoa p2 with(nolock) on  vv.cd_fornecedor = p2.cd_pes -- Alessandra 04/09/2019 - Ticket 100-155779
				left join DE_PARA DP with(nolock) on DP.Cd_Org = TT.Cd_Tp_Tx and DP.Cd_Cliente = PLLP.Cd_Pes_Grupo and DP.Cd_Tipo = 38-- -- Kaique 18/12/2025 - Ticket 100-538694

			WHERE 
				FATURA_PC=@Fatura_PC
			group by 
				HOU.Num_Proc_HEM,Data_PC,F.fatDtVenc,Obs_PC,obs_HEM,right(pp.Num_CPF_CNPJ,14),Fatura_PC,pp.Apelido,
				pp.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,hawb_HEM ,IFT.CD_TP_TX,
				DP.Cd_Dst,NOME_TP_TX,IFT.Vlr_RS, CNS.Nome_Raz_Soc, LDE.Nome_Local,Repasse_TX,p2.Nome_Raz_Soc  -- Alessandra 04/09/2019 - Ticket 100-155779
			union all
				SELECT 
					Data_PC,fatDtVenc,OBS_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ ,Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,
					RUA,Numero,Cidade,UF,max(Numero_PO_HEM) Referencia_Cliente,DI_RE_PC,org.nome_local Origem, 
					dst.nome_local Destino,hawb_HEM House,ITM.CD_TP_TX,				
					CASE
					WHEN cast(DP.Cd_Dst as varchar(100)) is null then TT.Nome_Tp_Tx
					else 
					cast(DP.Cd_Dst as varchar(100)) 
					end as NOME_TP_TX, -- Kaique 18/12/2025 - Ticket 100-538694
					VLR_PC, TP_PGTO, Obs_hem OBS_HOU, 
					CNS.Nome_Raz_Soc CNS, LDE.Nome_Local Local_Desemb,
					dbo.fBusca_Tarefa(HOU.Num_Proc_HEM,4) Dt_Desembaraco,
--					Data_PC,fatDtVenc Vencimento, 
					max(cch.num_nf_hem) num_nf,					
					max(isnull(CCH.ref_acesso_nf_hem,'')) [Site],
					Repasse_TX  
					,p2.Nome_Raz_Soc as [Shipper] -- Alessandra 04/09/2019 - Ticket 100-155779
				FROM 
					FATURA_CHB FAT with(nolock)
					JOIN FATURA_CHB_ITEM ITM with(nolock) ON ITM.FATURA_CC=FAT.FATURA_PC
					JOIN PESSOA PP with(nolock)ON PP.CD_PES=CD_PES_PC
					JOIN Pessoa_LLP PLLP ON PP.Cd_Pes = PLLP.Cd_Pes -- - Kaique 18/12/2025 - Ticket 100-538694
					LEFT Join Endereco ED with(nolock) on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
					LEFT JOIN HOUSE_EXP_MAR HOU with(nolock) ON HOU.NUM_PROC_HEM=LEFT(FATURA_PC,16)
					LEFT JOIN cta_cte_hou_exp_mar CCH with(nolock)on CCH.num_proc_hem = LEFT(FATURA_PC,16) 
					and CCH.num_nf_hem is not null AND CCH.REF_ACESSO_NF_HeM <> 'P'
					join Tipo_Taxa TT with(nolock) on TT.cd_tp_Tx=itm.cd_tp_Tx
					LEft Join PO_HEM PO with(nolock) on lefT(fat.fatura_pc,16)=po.num_proC_HEM AND ID_DC = 1
					Join Localidade Org with(nolock) on Org.cd_local=cd_org_HEM
					Join Localidade dst with(nolock)on dst.cd_local=cd_dst_HEM
					left join Pessoa CNS with(nolock) on CNS.cd_pes = HOU.cd_export_HEM
					Left Join Campo_Processo CP with(nolock) on CP.Num_Proc=left(@Fatura_PC,16) and Id_Campo=25
					Left Join Localidade LDE with(nolock) on LDE.cd_local=CP.Campo_Dados
					Left Join Fatura with(nolock)on fatcod=fatura_pc
					left join vwClienteALLJOBS vv with(nolock) on vv.num_proc=processo_pc -- Alessandra 04/09/2019 - Ticket 100-155779
					left join Pessoa p2 with(nolock) on  vv.cd_fornecedor = p2.cd_pes -- Alessandra 04/09/2019 - Ticket 100-155779
					left join DE_PARA DP with(nolock) on DP.Cd_Org = TT.Cd_Tp_Tx and DP.Cd_Cliente = PLLP.Cd_Pes_Grupo and DP.Cd_Tipo = 38-- -- Kaique 18/12/2025 - Ticket 100-538694

				WHERE 
					FATURA_PC=@FATURA_PC and IMPrime='S'
				group by 
					HOU.Num_Proc_HEM,Data_PC,fatDtVenc,OBS_PC,obs_hem,right(pp.Num_CPF_CNPJ,14),Fatura_PC,pp.Apelido,pp.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,hawb_HEM ,ITM.CD_TP_TX,DP.Cd_Dst,NOME_TP_TX,VLR_PC, TP_PGTO, CNS.Nome_Raz_Soc, LDE.Nome_Local
					,Repasse_TX,p2.Nome_Raz_Soc  -- Alessandra 04/09/2019 - Ticket 100-155779
			END
		
		IF left(@fatura_pc,2)='EA' and (len(@Fatura_PC) = 17 or len(@fatura_pc)=16)
			BEGIN
	--Transportation
		SELECT 
				Distinct
				Data_PC,F.fatDtVenc,OBS_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ ,Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,
				RUA,Numero,Cidade,UF,max(Numero_PO_HEA) Referencia_Cliente,DI_RE_PC,org.nome_local Origem, 
				dst.nome_local Destino,hawb_HEA House,IFT.CD_TP_TX,
				CASE
				WHEN cast(DP.Cd_Dst as varchar(100)) is null then NOME_TP_TX + ' ('+ @fatcod + ')'
				else 
				cast(DP.Cd_Dst as varchar(100))  + ' ('+ @fatcod + ')'
				end as NOME_TP_TX, -- Kaique 18/12/2025 - Ticket 100-538694
				IFT.Vlr_RS VLR_PC, 'B' TP_PGTO, Obs_HEA OBS_HOU, 
				CNS.Nome_Raz_Soc CNS, LDE.Nome_Local Local_Desemb,
				dbo.fBusca_Tarefa(HOU.Num_Proc_HEA,4) Dt_Desembaraco,
--				fatDtVenc Vencimento,
				max(CCH.num_nf_HEA) num_nf,				 
				max(isnull(CCH.ref_acesso_nf_HEA,'')) [Site],
				Repasse_TX  
				,p2.Nome_Raz_Soc as [Shipper] -- Alessandra 04/09/2019 - Ticket 100-155779
			FROM 
				FATURA_CHB FAT with(nolock)
				JOIN FATURA_CHB_ITEM ITM with(nolock) ON ITM.FATURA_CC=FAT.FATURA_PC
				Join Fatura FT with(nolock)on FT.fatcod=@fatcod
				Join Item_Fat IFT with(nolock)on FT.fatcod = IFT.FatCod
				JOIN PESSOA PP with(nolock) ON PP.CD_PES=CD_PES_PC
				JOIN Pessoa_LLP PLLP ON PP.Cd_Pes = PLLP.Cd_Pes -- - Kaique 18/12/2025 - Ticket 100-538694
				LEFT Join Endereco ED with(nolock) on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
				LEFT JOIN HOUSE_EXP_AER HOU with(nolock) ON HOU.NUM_PROC_HEA=LEFT(FATURA_PC,16)
				JOIN cta_cte_hou_EXP_AER CCH with(nolock) on CCH.num_proc_HEA = LEFT(FATURA_PC,16)  and cch.cd_tp_tx = IFT.cd_tp_tx
				join Tipo_Taxa TT with(nolock) on TT.cd_tp_Tx=IFT.cd_tp_Tx
				LEft Join PO_HEA PO with(nolock) on lefT(fat.fatura_pc,16)=po.num_proC_HEA AND ID_DC = 1
				Join Localidade Org with(nolock) on Org.cd_local=cd_org_HEA
				Join Localidade dst with(nolock) on dst.cd_local=cd_dst_HEA
				left join Pessoa CNS with(nolock) on CNS.cd_pes = HOU.cd_consig_HEA
				Left Join Campo_Processo CP with(nolock) on CP.Num_Proc=left(FATURA_PC,16) and Id_Campo=25
				Left Join Localidade LDE with(nolock) on LDE.cd_local=CP.Campo_Dados
				Left Join Fatura F with(nolock)on F.fatcod=fatura_pc
				left join vwClienteALLJOBS vv with(nolock) on vv.num_proc=processo_pc -- Alessandra 04/09/2019 - Ticket 100-155779
				left join Pessoa p2 with(nolock) on  vv.cd_fornecedor = p2.cd_pes -- Alessandra 04/09/2019 - Ticket 100-155779
				left join DE_PARA DP with(nolock) on DP.Cd_Org = TT.Cd_Tp_Tx and DP.Cd_Cliente = PLLP.Cd_Pes_Grupo and DP.Cd_Tipo = 38-- -- Kaique 18/12/2025 - Ticket 100-538694

			WHERE 
				FATURA_PC=@Fatura_PC
			group by 
				HOU.Num_Proc_HEA,Data_PC,F.fatDtVenc,Obs_PC,obs_HEA,right(pp.Num_CPF_CNPJ,14),Fatura_PC,pp.Apelido,
				pp.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,hawb_HEA ,IFT.CD_TP_TX,
				NOME_TP_TX,DP.cd_dst,IFT.Vlr_RS, CNS.Nome_Raz_Soc, LDE.Nome_Local,Repasse_TX,p2.Nome_Raz_Soc  -- Alessandra 04/09/2019 - Ticket 100-155779
			union all
				SELECT 
					Data_PC,fatDtVenc,obs_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ, Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,
					RUA,Numero,Cidade,UF,max(Numero_PO_HEA) Referencia_Cliente,DI_RE_PC,org.nome_local Origem, 
					dst.nome_local Destino,hawb_HEA House,ITM.CD_TP_TX,
					CASE
					WHEN cast(DP.Cd_Dst as varchar(100)) is null then TT.Nome_Tp_Tx
					else 
					cast(DP.Cd_Dst as varchar(100)) 
					end as NOME_TP_TX,					
					VLR_PC, TP_PGTO, Obs_hea OBS_HOU, 
					CNS.Nome_Raz_Soc CNS, LDE.Nome_Local Local_Desemb,
					dbo.fBusca_Tarefa(HOU.Num_Proc_HEA,4) Dt_Desembaraco,
--					Data_PC,fatDtVenc Vencimento, 
					Max(CCH.num_nf_hea) num_nf,					 
					max(isnull(CCH.ref_acesso_nf_hea,'')) [Site],
					Repasse_TX 
					,p2.Nome_Raz_Soc as [Shipper] -- Alessandra 04/09/2019 - Ticket 100-155779
				FROM 
					FATURA_CHB FAT with(nolock)
					JOIN FATURA_CHB_ITEM ITM with(nolock) ON ITM.FATURA_CC=FAT.FATURA_PC
					JOIN PESSOA PP with(nolock) ON PP.CD_PES=CD_PES_PC
					JOIN Pessoa_LLP PLLP ON PP.Cd_Pes = PLLP.Cd_Pes -- - Kaique 18/12/2025 - Ticket 100-538694
					LEFT Join Endereco ED with(nolock) on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
					LEFT JOIN HOUSE_EXP_aer HOU with(nolock) ON HOU.NUM_PROC_HEA=LEFT(FATURA_PC,16)
					LEFT JOIN cta_cte_hou_exp_aer CCH with(nolock) on CCH.num_proc_hea = LEFT(FATURA_PC,16) and CCH.num_nf_hea is not null AND CCH.REF_ACESSO_NF_Hea <> 'P' AND CCH.REF_ACESSO_NF_Hea is not null and cch.cd_tp_tx = ITM.cd_tp_tx
					join Tipo_Taxa TT with(nolock)on TT.cd_tp_Tx=itm.cd_tp_Tx
					LEft Join PO_HEA PO with(nolock) on lefT(fat.fatura_pc,16)=po.num_proC_HEA AND ID_DC = 1
					Join Localidade Org with(nolock) on Org.cd_local=cd_org_HEA
					Join  Localidade dst with(nolock) on dst.cd_local=cd_dst_HEA
					left join Pessoa CNS with(nolock) on CNS.cd_pes = HOU.cd_export_HEA
					Left Join Campo_Processo CP with(nolock) on CP.Num_Proc=left(@Fatura_PC,16) and Id_Campo=25
					Left Join Localidade LDE with(nolock) on LDE.cd_local=CP.Campo_Dados
					Left Join Fatura with(nolock) on fatcod=fatura_pc
					left join vwClienteALLJOBS vv with(nolock) on vv.num_proc=processo_pc -- Alessandra 04/09/2019 - Ticket 100-155779
					left join Pessoa p2 with(nolock) on  vv.cd_fornecedor = p2.cd_pes -- Alessandra 04/09/2019 - Ticket 100-155779
					left join DE_PARA DP with(nolock) on DP.Cd_Org = TT.Cd_Tp_Tx and DP.Cd_Cliente = PLLP.Cd_Pes_Grupo and DP.Cd_Tipo = 38-- -- Kaique 18/12/2025 - Ticket 100-538694

				where 
					FATURA_PC=@FATURA_PC and IMPrime='S'
				group by 
					HOU.Num_Proc_HEA,Data_PC,fatDtVenc,obs_PC,obs_hea,right(pp.Num_CPF_CNPJ,14), Fatura_PC,pp.Apelido,pp.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,hawb_HEA ,ITM.CD_TP_TX,NOME_TP_TX,DP.cd_dst,VLR_PC, TP_PGTO, CNS.Nome_Raz_Soc, LDE.Nome_Local
					,Repasse_TX,p2.Nome_Raz_Soc  -- Alessandra 04/09/2019 - Ticket 100-155779
			END

		IF left(@fatura_pc,2)='EA' and (len(@Fatura_PC) = 15 or len(@fatura_pc)=14)
			BEGIN
				SELECT 
					Data_PC,fatDtVenc,obs_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ, Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,
					RUA,Numero,Cidade,UF,max(Numero_PO) Referencia_Cliente,DI_RE_PC,org.nome_local Origem, 
					dst.nome_local Destino,Mawb_MEA HOUSE,ITM.CD_TP_TX,
					CASE
					WHEN cast(DP.Cd_Dst as varchar(100)) is null then TT.Nome_Tp_Tx
					else 
					cast(DP.Cd_Dst as varchar(100)) 
					end as NOME_TP_TX,		
					VLR_PC, TP_PGTO, Obs_MEA OBS_MAS,
					CNS.Nome_Raz_Soc CNS, LDE.Nome_Local Local_Desemb,
					dbo.fBusca_Tarefa(MAS.Num_Proc_MEA,4) Dt_Desembaraco,
--					Data_PC,fatDtVenc Vencimento, 
					--MAx(CCM.NUM_NF_MeA)) num_nf
					(select max(num_nf_mea) from cta_cte_mas_exp_aer where num_proc_mea = LEFT(FATURA_PC,14)) num_nf,
					(select top 1 ref_acesso_nf_mea from cta_cte_mas_exp_aer where num_proc_mea = LEFT(FATURA_PC,14)) [Site],
					
					Repasse_TX  
					,p2.Nome_Raz_Soc as [Shipper] -- Alessandra 04/09/2019 - Ticket 100-155779
				FROM 
					FATURA_CHB FAT with(nolock) 
					JOIN FATURA_CHB_ITEM ITM with(nolock) ON ITM.FATURA_CC=FAT.FATURA_PC
					JOIN PESSOA PP with(nolock) ON PP.CD_PES=CD_PES_PC
					JOIN Pessoa_LLP PLLP ON PP.Cd_Pes = PLLP.Cd_Pes -- - Kaique 18/12/2025 - Ticket 100-538694
					LEFT Join Endereco ED with(nolock) on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
					LEFT JOIN MASTER_EXP_aer MAS with(nolock) ON MAS.NUM_PROC_MEA=LEFT(FATURA_PC,14)
					--LEFT join cta_cte_mas_exp_AER CCM on CCM.num_proc_meA = LEFT(FATURA_PC,14) and CCM.NUM_NF_MeA IS NOT NULL AND CCM.REF_ACESSO_NF_MeA <> 'P' AND CCM.REF_ACESSO_NF_MEA is not null
					join Tipo_Taxa TT with(nolock) on TT.cd_tp_Tx=itm.cd_tp_Tx
					LEft Join PO_Master PO with(nolock) on lefT(fat.fatura_pc,14)=po.num_proC_Master AND ID_DC = 1
					Join Localidade Org with(nolock) on Org.cd_local=cd_org_MEA
					Join  Localidade dst with(nolock) on dst.cd_local=cd_dst_MEA
					left join Pessoa CNS with(nolock) on CNS.cd_pes = MAS.cd_export_MEA
					Left Join Campo_Processo CP with(nolock) on CP.Num_Proc=left(@Fatura_PC,14) and Id_Campo=25
					Left Join Localidade LDE with(nolock) on LDE.cd_local=CP.Campo_Dados
					Left Join Fatura with(nolock) on fatcod=fatura_pc
					left join vwClienteALLJOBS vv with(nolock) on vv.num_proc=processo_pc -- Alessandra 04/09/2019 - Ticket 100-155779
					left join Pessoa p2 with(nolock) on  vv.cd_fornecedor = p2.cd_pes -- Alessandra 04/09/2019 - Ticket 100-155779
					left join DE_PARA DP with(nolock) on DP.Cd_Org = TT.Cd_Tp_Tx and DP.Cd_Cliente = PLLP.Cd_Pes_Grupo and DP.Cd_Tipo = 38-- -- Kaique 18/12/2025 - Ticket 100-538694
				where 
					FATURA_PC=@FATURA_PC and IMPrime='S'
				group by 
					MAS.Num_Proc_MEA,Data_PC,fatDtVenc,obs_PC,obs_MEA,right(pp.Num_CPF_CNPJ,14), Fatura_PC,pp.Apelido,pp.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,Mawb_MEA ,ITM.CD_TP_TX,NOME_TP_TX,DP.cd_dst,VLR_PC, TP_PGTO, CNS.Nome_Raz_Soc, LDE.Nome_Local
					,Repasse_TX,p2.Nome_Raz_Soc  -- Alessandra 04/09/2019 - Ticket 100-155779
			END
			
		IF left(@fatura_pc,2)='EM' and (len(@Fatura_PC) = 15 or len(@fatura_pc)=14)
			BEGIN
				SELECT 
					Data_PC,fatDtVenc,obs_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ, Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,
					RUA,Numero,Cidade,UF,max(Numero_PO) Referencia_Cliente,DI_RE_PC,org.nome_local Origem, 
					dst.nome_local Destino,Mawb_mem HOUSE,ITM.CD_TP_TX,				
					CASE
					WHEN cast(DP.Cd_Dst as varchar(100)) is null then TT.Nome_Tp_Tx
					else 
					cast(DP.Cd_Dst as varchar(100)) 
					end as NOME_TP_TX, -- Kaique 18/12/2025 - Ticket 100-538694
					VLR_PC, TP_PGTO, Obs_mem OBS_MAS, 
					CNS.Nome_Raz_Soc CNS, LDE.Nome_Local Local_Desemb,
					dbo.fBusca_Tarefa(MAS.Num_Proc_MEM,4) Dt_Desembaraco,
--					Data_PC,fatDtVenc Vencimento, 
					--Max(CCM.NUM_NF_Mem) num_nf
					(select max(num_nf_mem) from cta_cte_mas_exp_mar where num_proc_mem = LEFT(FATURA_PC,14)) num_nf,
					(select top 1 ref_acesso_nf_mem from cta_cte_mas_exp_mar where num_proc_mem = LEFT(FATURA_PC,14)) [Site],
		
					Repasse_TX 
					,p2.Nome_Raz_Soc as [Shipper] -- Alessandra 04/09/2019 - Ticket 100-155779
				FROM
					FATURA_CHB FAT with(nolock)
					JOIN FATURA_CHB_ITEM ITM with(nolock) ON ITM.FATURA_CC=FAT.FATURA_PC
					JOIN PESSOA PP with(nolock) ON PP.CD_PES=CD_PES_PC
					JOIN Pessoa_LLP PLLP ON PP.Cd_Pes = PLLP.Cd_Pes -- - Kaique 18/12/2025 - Ticket 100-538694

					LEFT Join Endereco ED with(nolock) on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
					LEFT JOIN MASTER_EXP_mar MAS with(nolock) ON MAS.NUM_PROC_mem=LEFT(FATURA_PC,14)
					--LEFT join cta_cte_mas_exp_mar CCM on CCM.num_proc_mem = LEFT(FATURA_PC,14) and CCM.NUM_NF_MeM IS NOT NULL AND CCM.REF_ACESSO_NF_MeM <> 'P' AND CCM.REF_ACESSO_NF_MEM is not null
					join Tipo_Taxa TT with(nolock) on TT.cd_tp_Tx=itm.cd_tp_Tx
					LEft Join PO_Master PO with(nolock) on lefT(fat.fatura_pc,14)=po.num_proC_Master AND ID_DC = 1
					Join Localidade Org with(nolock) on Org.cd_local=cd_org_mem
					Join  Localidade dst with(nolock) on dst.cd_local=cd_dst_mem
					left join Pessoa CNS with(nolock) on CNS.cd_pes = MAS.cd_export_mem
					Left Join Campo_Processo CP with(nolock) on CP.Num_Proc=left(@Fatura_PC,14) and Id_Campo=25
					Left Join Localidade LDE with(nolock) on LDE.cd_local=CP.Campo_Dados
					Left Join Fatura with(nolock) on fatcod=fatura_pc
					left join vwClienteALLJOBS vv with(nolock) on vv.num_proc=processo_pc -- Alessandra 04/09/2019 - Ticket 100-155779
					left join Pessoa p2 with(nolock) on  vv.cd_fornecedor = p2.cd_pes -- Alessandra 04/09/2019 - Ticket 100-155779
					left join DE_PARA DP with(nolock) on DP.Cd_Org = TT.Cd_Tp_Tx and DP.Cd_Cliente = PLLP.Cd_Pes_Grupo and DP.Cd_Tipo = 38-- -- Kaique 18/12/2025 - Ticket 100-538694

				where 
					FATURA_PC=@FATURA_PC and IMPrime='S'
				group by 
					MAS.Num_Proc_MEM,Data_PC,fatDtVenc,obs_PC,obs_mem,right(pp.Num_CPF_CNPJ,14), Fatura_PC,pp.Apelido,pp.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,Mawb_mem ,ITM.CD_TP_TX,DP.Cd_Dst,NOME_TP_TX,VLR_PC, TP_PGTO, CNS.Nome_Raz_Soc, LDE.Nome_Local
					,Repasse_TX,p2.Nome_Raz_Soc  -- Alessandra 04/09/2019 - Ticket 100-155779
					
			END
			
		IF left(@fatura_pc,2)='IM' and (len(@Fatura_PC) = 15 OR len(@Fatura_PC) = 14)
			BEGIN
				SELECT 
					Data_PC,fatDtVenc,obs_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ, Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,
					RUA,Numero,Cidade,UF,max(Numero_PO) Referencia_Cliente,DI_RE_PC,org.nome_local Origem, 
					dst.nome_local Destino,Mawb_mim HOUSE,ITM.CD_TP_TX,
					CASE
					WHEN cast(DP.Cd_Dst as varchar(100)) is null then TT.Nome_Tp_Tx
					else 
					cast(DP.Cd_Dst as varchar(100)) 
					end as NOME_TP_TX, -- -- Kaique 18/12/2025 - Ticket 100-538694
					VLR_PC, TP_PGTO, Obs_mim OBS_MAS, 
					CNS.Nome_Raz_Soc CNS, LDE.Nome_Local Local_Desemb, 
					dbo.fBusca_Tarefa(MAS.Num_Proc_MIM,4) Dt_Desembaraco,
--					Data_PC,fatDtVenc Vencimento,
					--max(CCM.NUM_NF_MIM) num_nf
					(select max(num_nf_mim) from cta_cte_mas_imp_mar where num_proc_mim = LEFT(FATURA_PC,14)) num_nf,					
					(select top 1 ref_acesso_nf_mim from cta_cte_mas_imp_mar where num_proc_mim = LEFT(FATURA_PC,14)) [Site],
					
					Repasse_TX
					,p2.Nome_Raz_Soc as [Shipper] -- Alessandra 04/09/2019 - Ticket 100-155779
				FROM 
					FATURA_CHB FAT with(nolock)
					JOIN FATURA_CHB_ITEM ITM with(nolock) ON ITM.FATURA_CC=FAT.FATURA_PC
					JOIN PESSOA PP with(nolock) ON PP.CD_PES=CD_PES_PC
					JOIN Pessoa_LLP PLLP ON PP.Cd_Pes = PLLP.Cd_Pes -- - Kaique 18/12/2025 - Ticket 100-538694
					LEFT Join Endereco ED with(nolock) on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
					LEFT JOIN MASTER_imp_mar MAS with(nolock) ON MAS.NUM_PROC_mim=LEFT(FATURA_PC,14)
					--LEFT join cta_cte_mas_imp_mar CCM on CCM.num_proc_mim = LEFT(FATURA_PC,14) and CCM.NUM_NF_MIM IS NOT NULL AND CCM.REF_ACESSO_NF_MIM <> 'P' AND CCM.REF_ACESSO_NF_MIM is not null
					join Tipo_Taxa TT with(nolock) on TT.cd_tp_Tx=itm.cd_tp_Tx
					LEft Join PO_Master PO with(nolock) on lefT(fat.fatura_pc,14)=po.num_proC_Master AND ID_DC = 1
					Join Localidade Org with(nolock) on Org.cd_local=cd_org_mim
					Join  Localidade dst with(nolock) on dst.cd_local=cd_dst_mim
					left join Pessoa CNS with(nolock) on CNS.cd_pes = MAS.cd_consig_mim
					Left Join Campo_Processo CP with(nolock) on CP.Num_Proc=left(@Fatura_PC,14) and Id_Campo=25
					Left Join Localidade LDE with(nolock) on LDE.cd_local=CP.Campo_Dados
					Left Join Fatura with(nolock) on fatcod=fatura_pc
					left join vwClienteALLJOBS vv with(nolock) on vv.num_proc=processo_pc -- Alessandra 04/09/2019 - Ticket 100-155779
					left join Pessoa p2 with(nolock) on  vv.cd_fornecedor = p2.cd_pes -- Alessandra 04/09/2019 - Ticket 100-155779
					left join DE_PARA DP with(nolock) on DP.Cd_Org = TT.Cd_Tp_Tx and DP.Cd_Cliente = PLLP.Cd_Pes_Grupo and DP.Cd_Tipo = 38-- -- Kaique 18/12/2025 - Ticket 100-538694
				where 
					FATURA_PC=@FATURA_PC and IMPrime='S'
				group by 
					MAS.Num_Proc_MIM,Data_PC,fatDtVenc,obs_PC,obs_mim,right(pp.Num_CPF_CNPJ,14), Fatura_PC,pp.Apelido,pp.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,Mawb_mim ,ITM.CD_TP_TX,DP.Cd_Dst,NOME_TP_TX,VLR_PC, TP_PGTO, CNS.Nome_Raz_Soc, LDE.Nome_Local--,NUM_NF_MIM
					,Repasse_TX,p2.Nome_Raz_Soc  -- Kaique 18/12/2025 - Ticket 100-538694
			END
			
		IF left(@fatura_pc,2)='IA' and (len(@Fatura_PC) = 15 or len(@fatura_pc)=14)
			BEGIN
				SELECT 
					Data_PC,fatDtVenc,obs_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ, Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,
					RUA,Numero,Cidade,UF,max(Numero_PO) Referencia_Cliente,DI_RE_PC,org.nome_local Origem, 
					dst.nome_local Destino,Mawb_mia HOUSE,ITM.CD_TP_TX,
					CASE
					WHEN cast(DP.Cd_Dst as varchar(100)) is null then TT.Nome_Tp_Tx
					else 
					cast(DP.Cd_Dst as varchar(100))
					end as NOME_TP_TX, -- -- Kaique 18/12/2025 - Ticket 100-538694
					VLR_PC, TP_PGTO, Obs_mia OBS_MAS, 
					CNS.Nome_Raz_Soc CNS, LDE.Nome_Local Local_Desemb,
					dbo.fBusca_Tarefa(MAS.Num_Proc_MIA,4) Dt_Desembaraco ,
--					Data_PC,fatDtVenc Vencimento,
--					max(CCM.NUM_NF_MIA) num_nf
					(select max(num_nf_mia) from cta_cte_mas_imp_aer where num_proc_mia = LEFT(FATURA_PC,14)) num_nf,

					(select top 1 ref_acesso_nf_mia from cta_cte_mas_imp_aer where num_proc_mia = LEFT(FATURA_PC,14)) [Site],
					
					Repasse_TX
					,p2.Nome_Raz_Soc as [Shipper] -- Alessandra 04/09/2019 - Ticket 100-155779
				FROM 
					FATURA_CHB FAT with(nolock)
					JOIN FATURA_CHB_ITEM ITM with(nolock) ON ITM.FATURA_CC=FAT.FATURA_PC
					JOIN PESSOA PP with(nolock) ON PP.CD_PES=CD_PES_PC
					JOIN Pessoa_LLP PLLP ON PP.Cd_Pes = PLLP.Cd_Pes -- - Kaique 18/12/2025 - Ticket 100-538694
					LEFT Join Endereco ED with(nolock) on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
					LEFT JOIN MASTER_imp_aer MAS with(nolock) ON MAS.NUM_PROC_mia=LEFT(FATURA_PC,14)
					--LEFT join cta_cte_mas_imp_AER CCM on CCM.num_proc_miA = LEFT(FATURA_PC,14) and CCM.NUM_NF_MIA IS NOT NULL AND CCM.REF_ACESSO_NF_MIA <> 'P' AND CCM.REF_ACESSO_NF_MIA is not null
					join Tipo_Taxa TT with(nolock) on TT.cd_tp_Tx=itm.cd_tp_Tx
					LEft Join PO_Master PO with(nolock) on lefT(fat.fatura_pc,14)=po.num_proC_Master AND ID_DC = 1
					Join Localidade Org with(nolock) on Org.cd_local=cd_org_mia
					Join  Localidade dst with(nolock) on dst.cd_local=cd_dst_mia
					left join Pessoa CNS with(nolock) on CNS.cd_pes = MAS.cd_consig_mia
					Left Join Campo_Processo CP with(nolock) on CP.Num_Proc=left(@Fatura_PC,14) and Id_Campo=25
					Left Join Localidade LDE with(nolock) on LDE.cd_local=CP.Campo_Dados
					Left Join Fatura with(nolock) on fatcod=fatura_pc
					left join vwClienteALLJOBS vv with(nolock) on vv.num_proc=processo_pc -- Alessandra 04/09/2019 - Ticket 100-155779
					left join Pessoa p2 with(nolock) on  vv.cd_fornecedor = p2.cd_pes -- Alessandra 04/09/2019 - Ticket 100-155779
					left join DE_PARA DP with(nolock) on DP.Cd_Org = TT.Cd_Tp_Tx and DP.Cd_Cliente = PLLP.Cd_Pes_Grupo and DP.Cd_Tipo = 38-- -- Kaique 18/12/2025 - Ticket 100-538694
				where 
					FATURA_PC=@FATURA_PC and IMPrime='S'
				group by 
					MAS.Num_Proc_MIA,Data_PC,fatDtVenc,obs_PC,obs_mia,right(pp.Num_CPF_CNPJ,14), Fatura_PC,pp.Apelido,pp.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,Mawb_mia ,ITM.CD_TP_TX,DP.cd_dst,NOME_TP_TX,VLR_PC, TP_PGTO, CNS.Nome_Raz_Soc, LDE.Nome_Local--NUM_NF_MIA
					,Repasse_TX,p2.Nome_Raz_Soc  -- Alessandra 04/09/2019 - Ticket 100-155779
			END
		end
Else IF @TIPO='F'
	BEGIN
	
		if left(@fatura_pc,2)='BO' and (len(@Fatura_PC) = 17 or len(@fatura_pc)=16)
		BEGIN
			SELECT 
				Top 1
				Data_PC,fatDtVenc,Obs_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ ,Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,
				RUA,Numero,Cidade,UF,max(Numero_PO_HBO) Referencia_Cliente,DI_RE_PC,
				'' Origem, 
				'' Destino,
				'' House,
--				ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO,
				Null CD_TP_TX,Null NOME_TP_TX, NUll VLR_PC, TP_PGTO,
				FAt.Obs_PC OBS_HOU, CNS.Nome_Raz_Soc CNS, LDE.Nome_Local Local_Desemb,
				dbo.fBusca_Tarefa(HOU.Num_Proc_HBO,4) Dt_Desembaraco,
--				Data_PC,fatDtVenc Vencimento, 
				Max(CCH.Num_NF_HBO) num_nf,
				max(isnull(CCH.Ref_Acesso_NF_HBO,'')) [Site],
				Repasse_TX  
				,[dbo].[fBusca_Docs_PO_Modal](LEFT(FATURA_PC,16),19) Num_Proc_HBO -- Antonio 100-386207 - Ao fechar os jobs (BOS) estão com erro, tipo de taxas 
				,p2.Nome_Raz_Soc as [Shipper] -- Alessandra 04/09/2019 - Ticket 100-155779
			FROM 
				FATURA_CHB FAT with(nolock)
				JOIN FATURA_CHB_ITEM ITM with(nolock) ON ITM.FATURA_CC=FAT.FATURA_PC
				JOIN PESSOA PP with(nolock) ON PP.CD_PES=CD_PES_PC 
				LEFT Join Endereco ED with(nolock) on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
				LEFT JOIN House_BDP_OUT HOU with(nolock) ON HOU.Num_Proc_HBO=LEFT(FATURA_PC,16)
				LEFT JOIN Cta_Cte_HOU_BDP_OUT CCH with(nolock) on CCH.Num_Proc_HBO = LEFT(FATURA_PC,16) and CCH.Num_NF_HBO is not null AND CCH.Ref_Acesso_NF_HBO  <> 'P' AND CCH.Ref_Acesso_NF_HBO is not null and cch.cd_tp_tx = ITM.cd_tp_tx
				join Tipo_Taxa TT with(nolock) on TT.cd_tp_Tx=itm.cd_tp_Tx
				LEft Join PO_HBO PO with(nolock) on lefT(fat.fatura_pc,16)=po.Num_Proc_HBO AND ID_DC = 1
				--Join Localidade Org with(nolock) on Org.cd_local=cd_org_HEO
				--Join Localidade dst with(nolock) on dst.cd_local=cd_dst_HEO
				left join Pessoa CNS with(nolock) on CNS.cd_pes = HOU.cd_cliente_HBO
				Left Join Campo_Processo CP with(nolock) on CP.Num_Proc=left(@Fatura_PC,16) and Id_Campo=25
				Left Join Localidade LDE with(nolock) on LDE.cd_local=CP.Campo_Dados
				Left Join Fatura with(nolock) on fatcod=fatura_pc
				left join vwClienteALLJOBS vv with(nolock) on vv.num_proc=processo_pc -- Alessandra 04/09/2019 - Ticket 100-155779
				left join Pessoa p2 with(nolock) on  vv.cd_fornecedor = p2.cd_pes -- Alessandra 04/09/2019 - Ticket 100-155779

			WHERE 
				FATURA_PC=@FATURA_PC --and imprime='S'
			group by 
				HOU.Num_Proc_HBO, Data_pc,fatDtVenc,Obs_Pc,fat.Obs_PC,right(PP.Num_CPF_CNPJ,14),
				Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC
				--,org.nome_local , dst.nome_local ,hawb_HEO 
				,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, CNS.Nome_Raz_Soc, LDE.Nome_Local
				,Repasse_TX ,p2.Nome_Raz_Soc  -- Alessandra 04/09/2019 - Ticket 100-155779
		END

	    if left(@fatura_pc,2)='EO' and (len(@Fatura_PC) = 17 or len(@fatura_pc)=16)
		BEGIN
			SELECT 
				Top 1
				Data_PC,fatDtVenc,Obs_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ ,Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,
				RUA,Numero,Cidade,UF,max(Numero_PO_HEO) Referencia_Cliente,DI_RE_PC,org.nome_local Origem, 
				dst.nome_local Destino,hawb_HEO House,
--				ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO,
				Null CD_TP_TX,Null NOME_TP_TX, NUll VLR_PC, TP_PGTO,
				Obs_heo OBS_HOU, CNS.Nome_Raz_Soc CNS, LDE.Nome_Local Local_Desemb,
				dbo.fBusca_Tarefa(HOU.Num_Proc_HEO,4) Dt_Desembaraco,
--				Data_PC,fatDtVenc Vencimento, 
				Max(CCH.num_nf_heo) num_nf,

				max(isnull(CCH.ref_acesso_nf_heo,'')) [Site],
				Repasse_TX  
				,p2.Nome_Raz_Soc as [Shipper] -- Alessandra 04/09/2019 - Ticket 100-155779
			FROM 
				FATURA_CHB FAT with(nolock)
				JOIN FATURA_CHB_ITEM ITM with(nolock) ON ITM.FATURA_CC=FAT.FATURA_PC
				JOIN PESSOA PP with(nolock) ON PP.CD_PES=CD_PES_PC 
				LEFT Join Endereco ED with(nolock) on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
				LEFT JOIN HOUSE_EXP_OUT HOU with(nolock) ON HOU.NUM_PROC_HEO=LEFT(FATURA_PC,16)
				LEFT JOIN cta_cte_hou_exp_out CCH with(nolock) on CCH.num_proc_heo = LEFT(FATURA_PC,16) and CCH.num_nf_heo is not null AND CCH.REF_ACESSO_NF_Heo <> 'P' AND CCH.REF_ACESSO_NF_Heo is not null and cch.cd_tp_tx = ITM.cd_tp_tx
				join Tipo_Taxa TT with(nolock) on TT.cd_tp_Tx=itm.cd_tp_Tx
				LEft Join PO_HEO PO with(nolock) on lefT(fat.fatura_pc,16)=po.num_proC_HEO AND ID_DC = 1
				Join Localidade Org with(nolock) on Org.cd_local=cd_org_HEO
				Join Localidade dst with(nolock) on dst.cd_local=cd_dst_HEO
				left join Pessoa CNS with(nolock) on CNS.cd_pes = HOU.cd_export_HEO
				Left Join Campo_Processo CP with(nolock) on CP.Num_Proc=left(@Fatura_PC,16) and Id_Campo=25
				Left Join Localidade LDE with(nolock) on LDE.cd_local=CP.Campo_Dados
				Left Join Fatura with(nolock) on fatcod=fatura_pc
				left join vwClienteALLJOBS vv with(nolock) on vv.num_proc=processo_pc -- Alessandra 04/09/2019 - Ticket 100-155779
				left join Pessoa p2 with(nolock) on  vv.cd_fornecedor = p2.cd_pes -- Alessandra 04/09/2019 - Ticket 100-155779
			WHERE 
				FATURA_PC=@FATURA_PC --and imprime='S'
			group by 
				HOU.Num_Proc_HEO, Data_pc,fatDtVenc,Obs_Pc,Obs_Heo,right(PP.Num_CPF_CNPJ,14),Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,hawb_HEO ,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, CNS.Nome_Raz_Soc, LDE.Nome_Local
				,Repasse_TX ,p2.Nome_Raz_Soc  -- Alessandra 04/09/2019 - Ticket 100-155779
		END

	    if left(@fatura_pc,2)='IO' and (len(@Fatura_PC) = 17 or len(@fatura_pc)=16)
		BEGIN
			SELECT 
				top 1 
				Data_PC,fatDtVenc,Obs_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ ,Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,
				RUA,Numero,Cidade,UF,max(Numero_PO_HIO) Referencia_Cliente,DI_RE_PC,org.nome_local Origem, 
				dst.nome_local Destino,hawb_HIO House,Null CD_TP_TX,null NOME_TP_TX,null VLR_PC, TP_PGTO,Obs_hio OBS_HOU, 
				CNS.Nome_Raz_Soc CNS, LDE.Nome_Local Local_Desemb,
				dbo.fBusca_Tarefa(HOU.Num_Proc_HIO,4) Dt_Desembaraco,
--				Data_PC,fatDtVenc Vencimento, 
				MAx(cch.num_nf_hio) num_nf,

				Max(isnull(CCH.ref_acesso_nf_hio,'')) [Site],
				Repasse_TX 
				,p2.Nome_Raz_Soc as [Shipper] -- Alessandra 04/09/2019 - Ticket 100-155779
			FROM 
				FATURA_CHB FAT with(nolock)
				JOIN FATURA_CHB_ITEM ITM with(nolock) ON ITM.FATURA_CC=FAT.FATURA_PC
				JOIN PESSOA PP with(nolock) ON PP.CD_PES=CD_PES_PC 
				LEFT Join Endereco ED with(nolock) on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
				LEFT JOIN HOUSE_IMP_OUT HOU with(nolock) ON HOU.NUM_PROC_HIO=LEFT(FATURA_PC,16)
				LEFT JOIN cta_cte_hou_imp_out CCH with(nolock) on CCH.num_proc_hio = LEFT(FATURA_PC,16) and CCH.num_nf_hio is not null AND CCH.REF_ACESSO_NF_HIo <> 'P' AND CCH.REF_ACESSO_NF_Hio is not null and cch.cd_tp_tx = ITM.cd_tp_tx
				join Tipo_Taxa TT with(nolock) on TT.cd_tp_Tx=itm.cd_tp_Tx
				LEft Join PO_HIO PO with(nolock) on lefT(fat.fatura_pc,16)=po.num_proC_HIO AND ID_DC = 1
				Join Localidade Org with(nolock) on Org.cd_local=cd_org_HIO
				Join Localidade dst with(nolock) on dst.cd_local=cd_dst_HIO
				left join Pessoa CNS with(nolock) on CNS.cd_pes = HOU.cd_consig_HIO
				Left Join Campo_Processo CP with(nolock) on CP.Num_Proc=left(@Fatura_PC,16) and Id_Campo=25
				Left Join Localidade LDE with(nolock) on LDE.cd_local=CP.Campo_Dados
				Left Join Fatura with(nolock) on fatcod=fatura_pc
				left join vwClienteALLJOBS vv with(nolock) on vv.num_proc=processo_pc -- Alessandra 04/09/2019 - Ticket 100-155779
				left join Pessoa p2 with(nolock) on  vv.cd_fornecedor = p2.cd_pes -- Alessandra 04/09/2019 - Ticket 100-155779

			WHERE 
				FATURA_PC=@FATURA_PC   
			group by 
				HOU.Num_Proc_HIO,Data_PC,fatDtVenc,Obs_PC,obs_hio,right(PP.Num_CPF_CNPJ,14),Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,hawb_HIO ,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, CNS.Nome_Raz_Soc, LDE.Nome_Local
				,Repasse_TX ,p2.Nome_Raz_Soc  -- Alessandra 04/09/2019 - Ticket 100-155779
		END

	    if left(@fatura_pc,2)='IM' and (len(@Fatura_PC) = 17 or len(@Fatura_PC) = 16)
		BEGIN
			SELECT 
				top 1
				Data_PC,fatDtVenc,OBS_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ ,Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,
				RUA,Numero,Cidade,UF,max(Numero_PO_HIM) Referencia_Cliente,DI_RE_PC,org.nome_local Origem, 
				dst.nome_local Destino,hawb_him House,Null CD_TP_TX,Null NOME_TP_TX,Null VLR_PC, TP_PGTO, Obs_him OBS_HOU,
				CNS.Nome_Raz_Soc CNS, LDE.Nome_Local Local_Desemb,
				dbo.fBusca_Tarefa(HOU.Num_Proc_HIM,4) Dt_Desembaraco,
--				fatDtVenc Vencimento,
				max(CCH.num_nf_him) num_nf,

				max(isnull(CCH.ref_acesso_nf_him,'')) [Site],
				Repasse_TX  
				,p2.Nome_Raz_Soc as [Shipper] -- Alessandra 04/09/2019 - Ticket 100-155779
			FROM 
				FATURA_CHB FAT with(nolock)
				JOIN FATURA_CHB_ITEM ITM with(nolock) ON ITM.FATURA_CC=FAT.FATURA_PC
				JOIN PESSOA PP with(nolock) ON PP.CD_PES=CD_PES_PC
				LEFT Join Endereco ED with(nolock) on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
				LEFT JOIN HOUSE_IMP_MAR HOU with(nolock) ON HOU.NUM_PROC_HIM=LEFT(FATURA_PC,16)
				LEFT JOIN cta_cte_hou_imp_mar CCH with(nolock) on CCH.num_proc_him = LEFT(FATURA_PC,16) and CCH.num_nf_him is not null AND CCH.REF_ACESSO_NF_HIM <> 'P' AND CCH.REF_ACESSO_NF_Him is not null and cch.cd_tp_tx = ITM.cd_tp_tx
				join Tipo_Taxa TT with(nolock) on TT.cd_tp_Tx=itm.cd_tp_Tx
				LEft Join PO_HIM PO with(nolock) on lefT(fat.fatura_pc,16)=po.num_proC_him AND ID_DC = 1
				Join Localidade Org with(nolock) on Org.cd_local=cd_org_him
				Join Localidade dst with(nolock) on dst.cd_local=cd_dst_him
				left join Pessoa CNS with(nolock) on CNS.cd_pes = HOU.cd_consig_HIM
				Left Join Campo_Processo CP with(nolock) on CP.Num_Proc=left(@Fatura_PC,16) and Id_Campo=25
				Left Join Localidade LDE with(nolock) on LDE.cd_local=CP.Campo_Dados
				Left Join Fatura with(nolock) on fatcod=fatura_pc
				left join vwClienteALLJOBS vv with(nolock) on vv.num_proc=processo_pc -- Alessandra 04/09/2019 - Ticket 100-155779
				left join Pessoa p2 with(nolock) on  vv.cd_fornecedor = p2.cd_pes -- Alessandra 04/09/2019 - Ticket 100-155779

			WHERE 
				FATURA_PC=@FATURA_PC --and imprime='S'
			group by 
				HOU.Num_Proc_HIM,Data_PC,fatDtVenc,Obs_PC,obs_him,right(pp.Num_CPF_CNPJ,14),Fatura_PC,pp.Apelido,pp.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,hawb_him ,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, CNS.Nome_Raz_Soc, LDE.Nome_Local
				,Repasse_TX ,p2.Nome_Raz_Soc  -- Alessandra 04/09/2019 - Ticket 100-155779
		
	END
		
		IF left(@fatura_pc,2)='IA' and (len(@Fatura_PC) = 17 or len(@fatura_pc)=16)
			BEGIN
				SELECT Top 1
					Data_PC,fatDtVenc,Obs_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ, Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,
					RUA,Numero,Cidade,UF, max(Numero_PO_hia) Referencia_Cliente,DI_RE_PC,org.nome_local Origem, 
					dst.nome_local Destino,hawb_hia House,NULL CD_TP_TX,NULL NOME_TP_TX,NULL VLR_PC, TP_PGTO, Obs_hia OBS_HOU, 
					CNS.Nome_Raz_Soc CNS, LDE.Nome_Local Local_Desemb,
					dbo.fBusca_Tarefa(HOU.Num_Proc_HIA,4) Dt_Desembaraco,
--					Data_PC,fatDtVenc Vencimento, 
					Max(cch.num_nf_hia) num_nf,

					Max(isnull(CCH.ref_acesso_nf_hia,'')) [Site],
					Repasse_TX
					,p2.Nome_Raz_Soc as [Shipper] -- Alessandra 04/09/2019 - Ticket 100-155779  
				FROM 
					FATURA_CHB FAT with(nolock)
					JOIN FATURA_CHB_ITEM ITM with(nolock) ON ITM.FATURA_CC=FAT.FATURA_PC
					JOIN PESSOA PP with(nolock) ON PP.CD_PES=CD_PES_PC
					LEFT Join Endereco ED with(nolock) on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
					LEFT JOIN HOUSE_IMP_aer HOU with(nolock) ON HOU.NUM_PROC_hia=LEFT(FATURA_PC,16)
					LEFT JOIN cta_cte_hou_imp_aer CCH with(nolock) on CCH.num_proc_hia = LEFT(FATURA_PC,16) and CCH.num_nf_hia is not null AND CCH.REF_ACESSO_NF_HIa <> 'P' AND CCH.REF_ACESSO_NF_Hia is not null and cch.cd_tp_tx = ITM.cd_tp_tx
					join Tipo_Taxa TT with(nolock) on TT.cd_tp_Tx=itm.cd_tp_Tx
					LEft Join PO_hia PO with(nolock) on lefT(fat.fatura_pc,16)=po.num_proC_hia  AND ID_DC = 1
					Join Localidade Org with(nolock) on Org.cd_local=cd_org_hia
					Join Localidade dst with(nolock) on dst.cd_local=cd_dst_hia
					left join Pessoa CNS with(nolock) on CNS.cd_pes = HOU.cd_consig_HIA
					Left Join Campo_Processo CP with(nolock) on CP.Num_Proc=left(@Fatura_PC,16) and Id_Campo=25
					Left Join Localidade LDE with(nolock) on LDE.cd_local=CP.Campo_Dados
					Left Join Fatura with(nolock) on fatcod=fatura_pc
					left join vwClienteALLJOBS vv with(nolock) on vv.num_proc=processo_pc -- Alessandra 04/09/2019 - Ticket 100-155779
					left join Pessoa p2 with(nolock) on  vv.cd_fornecedor = p2.cd_pes -- Alessandra 04/09/2019 - Ticket 100-155779

				WHERE 
					FATURA_PC=@FATURA_PC --and imprime='S'
				group by 
					HOU.Num_Proc_HIA,Data_PC,fatDtVenc,obs_PC,obs_hia,right(pp.Num_CPF_CNPJ,14), Fatura_PC,pp.Apelido,pp.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,hawb_hia ,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, CNS.Nome_Raz_Soc, LDE.Nome_Local
					,Repasse_TX ,p2.Nome_Raz_Soc  -- Alessandra 04/09/2019 - Ticket 100-155779
			END	
				
		IF left(@fatura_pc,2)='EM' and (len(@Fatura_PC) = 17 or len(@fatura_pc)=16)
			BEGIN
				SELECT Top 1 
					Data_PC,fatDtVenc,OBS_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ ,Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,
					RUA,Numero,Cidade,UF,max(Numero_PO_HEM) Referencia_Cliente,DI_RE_PC,org.nome_local Origem, 
					dst.nome_local Destino,hawb_HEM House,NULL CD_TP_TX,NULL NOME_TP_TX,NULL VLR_PC, TP_PGTO, Obs_hem OBS_HOU, 
					CNS.Nome_Raz_Soc CNS, LDE.Nome_Local Local_Desemb,
					dbo.fBusca_Tarefa(HOU.Num_Proc_HEM,4) Dt_Desembaraco,
--					Data_PC,fatDtVenc Vencimento,
					 max(cch.num_nf_hem) num_nf,

					max(isnull(CCH.ref_acesso_nf_hem,'')) [Site],
					Repasse_TX
					,p2.Nome_Raz_Soc as [Shipper] -- Alessandra 04/09/2019 - Ticket 100-155779 
				FROM 
					FATURA_CHB FAT with(nolock)
					JOIN FATURA_CHB_ITEM ITM with(nolock) ON ITM.FATURA_CC=FAT.FATURA_PC
					JOIN PESSOA PP with(nolock) ON PP.CD_PES=CD_PES_PC
					LEFT Join Endereco ED with(nolock) on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
					LEFT JOIN HOUSE_EXP_MAR HOU with(nolock) ON HOU.NUM_PROC_HEM=LEFT(FATURA_PC,16)
					LEFT JOIN cta_cte_hou_exp_mar CCH with(nolock) on CCH.num_proc_hem = LEFT(FATURA_PC,16) 
					and CCH.num_nf_hem is not null AND CCH.REF_ACESSO_NF_HeM <> 'P'
					join Tipo_Taxa TT with(nolock) on TT.cd_tp_Tx=itm.cd_tp_Tx
					LEft Join PO_HEM PO with(nolock) on lefT(fat.fatura_pc,16)=po.num_proC_HEM AND ID_DC = 1
					Join Localidade Org with(nolock) on Org.cd_local=cd_org_HEM
					Join Localidade dst with(nolock) on dst.cd_local=cd_dst_HEM
					left join Pessoa CNS with(nolock) on CNS.cd_pes = HOU.cd_export_HEM
					Left Join Campo_Processo CP with(nolock) on CP.Num_Proc=left(@Fatura_PC,16) and Id_Campo=25
					Left Join Localidade LDE with(nolock) on LDE.cd_local=CP.Campo_Dados
					Left Join Fatura with(nolock) on fatcod=fatura_pc
					left join vwClienteALLJOBS vv with(nolock) on vv.num_proc=processo_pc -- Alessandra 04/09/2019 - Ticket 100-155779
					left join Pessoa p2 with(nolock) on  vv.cd_fornecedor = p2.cd_pes -- Alessandra 04/09/2019 - Ticket 100-155779

				WHERE 
					FATURA_PC=@FATURA_PC --and IMPrime='S'
				group by 
					HOU.Num_Proc_HEM,Data_PC,fatDtVenc,OBS_PC,obs_hem,right(pp.Num_CPF_CNPJ,14),Fatura_PC,pp.Apelido,pp.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,hawb_HEM ,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, CNS.Nome_Raz_Soc, LDE.Nome_Local
					,Repasse_TX,p2.Nome_Raz_Soc  -- Alessandra 04/09/2019 - Ticket 100-155779 
			END
		
		IF left(@fatura_pc,2)='EA' and (len(@Fatura_PC) = 17 or len(@fatura_pc)=16)
			BEGIN
			
				SELECT Top 1
					Data_PC,fatDtVenc,obs_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ, Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,
					RUA,Numero,Cidade,UF,max(Numero_PO_HEA) Referencia_Cliente,DI_RE_PC,org.nome_local Origem, 
					dst.nome_local Destino,hawb_HEA House,NULL CD_TP_TX,NULL NOME_TP_TX,NULL VLR_PC, TP_PGTO, Obs_hea OBS_HOU, 
					CNS.Nome_Raz_Soc CNS, LDE.Nome_Local Local_Desemb,
					dbo.fBusca_Tarefa(HOU.Num_Proc_HEA,4) Dt_Desembaraco,
--					Data_PC,fatDtVenc Vencimento, 
					Max(CCH.num_nf_hea) num_nf,

					max(isnull(CCH.ref_acesso_nf_hea,'')) [Site],
					Repasse_TX
					,p2.Nome_Raz_Soc as [Shipper] -- Alessandra 04/09/2019 - Ticket 100-155779 
				FROM 
					FATURA_CHB FAT with(nolock)
					JOIN FATURA_CHB_ITEM ITM with(nolock) ON ITM.FATURA_CC=FAT.FATURA_PC
					JOIN PESSOA PP with(nolock)ON PP.CD_PES=CD_PES_PC
					LEFT Join Endereco ED with(nolock) on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
					LEFT JOIN HOUSE_EXP_aer HOU with(nolock) ON HOU.NUM_PROC_HEA=LEFT(FATURA_PC,16)
					LEFT JOIN cta_cte_hou_exp_aer CCH with(nolock) on CCH.num_proc_hea = LEFT(FATURA_PC,16) and CCH.num_nf_hea is not null AND CCH.REF_ACESSO_NF_Hea <> 'P' AND CCH.REF_ACESSO_NF_Hea is not null and cch.cd_tp_tx = ITM.cd_tp_tx
					join Tipo_Taxa TT with(nolock) on TT.cd_tp_Tx=itm.cd_tp_Tx
					LEft Join PO_HEA PO with(nolock) on lefT(fat.fatura_pc,16)=po.num_proC_HEA AND ID_DC = 1
					Join Localidade Org with(nolock) on Org.cd_local=cd_org_HEA
					Join  Localidade dst with(nolock) on dst.cd_local=cd_dst_HEA
					left join Pessoa CNS with(nolock) on CNS.cd_pes = HOU.cd_export_HEA
					Left Join Campo_Processo CP with(nolock) on CP.Num_Proc=left(@Fatura_PC,16) and Id_Campo=25
					Left Join Localidade LDE with(nolock) on LDE.cd_local=CP.Campo_Dados
					Left Join Fatura with(nolock) on fatcod=fatura_pc
					left join vwClienteALLJOBS vv with(nolock) on vv.num_proc=processo_pc -- Alessandra 04/09/2019 - Ticket 100-155779
					left join Pessoa p2 with(nolock) on  vv.cd_fornecedor = p2.cd_pes -- Alessandra 04/09/2019 - Ticket 100-155779
				where 
					FATURA_PC=@FATURA_PC --and IMPrime='S'
				group by 
					HOU.Num_Proc_HEA,Data_PC,fatDtVenc,obs_PC,obs_hea,right(pp.Num_CPF_CNPJ,14), Fatura_PC,pp.Apelido,pp.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,hawb_HEA ,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, CNS.Nome_Raz_Soc, LDE.Nome_Local
					,Repasse_TX,p2.Nome_Raz_Soc  -- Alessandra 04/09/2019 - Ticket 100-155779 
			END

		IF left(@fatura_pc,2)='EA' and (len(@Fatura_PC) = 15 or len(@fatura_pc)=14)
			BEGIN
				SELECT Top 1
					Data_PC,fatDtVenc,obs_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ, Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,
					RUA,Numero,Cidade,UF,max(Numero_PO) Referencia_Cliente,DI_RE_PC,org.nome_local Origem, 
					dst.nome_local Destino,Mawb_MEA HOUSE,NULL CD_TP_TX,NULL NOME_TP_TX,NULL VLR_PC, TP_PGTO, Obs_MEA OBS_MAS, 
					CNS.Nome_Raz_Soc CNS, LDE.Nome_Local Local_Desemb,
					dbo.fBusca_Tarefa(MAS.Num_Proc_MEA,4) Dt_Desembaraco,
--					Data_PC,fatDtVenc Vencimento, 
					--MAx(CCM.NUM_NF_MeA)) num_nf
					(select max(num_nf_mea) from cta_cte_mas_exp_aer where num_proc_mea = LEFT(FATURA_PC,14)) num_nf,

					(select top 1 ref_acesso_nf_mea from cta_cte_mas_exp_aer where num_proc_mea = LEFT(FATURA_PC,14)) [Site],					
					Repasse_TX
					,p2.Nome_Raz_Soc as [Shipper] -- Alessandra 04/09/2019 - Ticket 100-155779
				FROM 
					FATURA_CHB FAT with(nolock)
					JOIN FATURA_CHB_ITEM ITM with(nolock) ON ITM.FATURA_CC=FAT.FATURA_PC
					JOIN PESSOA PP with(nolock) ON PP.CD_PES=CD_PES_PC
					LEFT Join Endereco ED with(nolock) on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
					LEFT JOIN MASTER_EXP_aer MAS with(nolock) ON MAS.NUM_PROC_MEA=LEFT(FATURA_PC,14)
					--LEFT join cta_cte_mas_exp_AER CCM on CCM.num_proc_meA = LEFT(FATURA_PC,14) and CCM.NUM_NF_MeA IS NOT NULL AND CCM.REF_ACESSO_NF_MeA <> 'P' AND CCM.REF_ACESSO_NF_MEA is not null
					join Tipo_Taxa TT with(nolock) on TT.cd_tp_Tx=itm.cd_tp_Tx
					LEft Join PO_Master PO with(nolock) on lefT(fat.fatura_pc,14)=po.num_proC_Master AND ID_DC = 1
					Join Localidade Org with(nolock) on Org.cd_local=cd_org_MEA
					Join  Localidade dst with(nolock) on dst.cd_local=cd_dst_MEA
					left join Pessoa CNS with(nolock) on CNS.cd_pes = MAS.cd_export_MEA
					Left Join Campo_Processo CP with(nolock) on CP.Num_Proc=left(@Fatura_PC,14) and Id_Campo=25
					Left Join Localidade LDE with(nolock)on LDE.cd_local=CP.Campo_Dados
					Left Join Fatura with(nolock) on fatcod=fatura_pc
					left join vwClienteALLJOBS vv with(nolock) on vv.num_proc=processo_pc -- Alessandra 04/09/2019 - Ticket 100-155779
					left join Pessoa p2 with(nolock) on  vv.cd_fornecedor = p2.cd_pes -- Alessandra 04/09/2019 - Ticket 100-155779

				where 
					FATURA_PC=@FATURA_PC --and IMPrime='S'
				group by 
					MAS.Num_Proc_MEA,Data_PC,fatDtVenc,obs_PC,obs_MEA,right(pp.Num_CPF_CNPJ,14), Fatura_PC,pp.Apelido,pp.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,Mawb_MEA ,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, CNS.Nome_Raz_Soc, LDE.Nome_Local
					,Repasse_TX,p2.Nome_Raz_Soc  -- Alessandra 04/09/2019 - Ticket 100-155779 
			END
			
		IF left(@fatura_pc,2)='EM' and (len(@Fatura_PC) = 15 or len(@fatura_pc)=14)
			BEGIN
				SELECT Top 1
					Data_PC,fatDtVenc,obs_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ, Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,
					RUA,Numero,Cidade,UF,max(Numero_PO) Referencia_Cliente,DI_RE_PC,org.nome_local Origem, 
					dst.nome_local Destino,Mawb_mem HOUSE,NULL CD_TP_TX,NULL NOME_TP_TX,NULL VLR_PC, TP_PGTO, Obs_mem OBS_MAS, 
					CNS.Nome_Raz_Soc CNS, LDE.Nome_Local Local_Desemb,
					dbo.fBusca_Tarefa(MAS.Num_Proc_MEM,4) Dt_Desembaraco,
--					Data_PC,fatDtVenc Vencimento, 
					--Max(CCM.NUM_NF_Mem) num_nf
					(select max(num_nf_mem) from cta_cte_mas_exp_mar where num_proc_mem = LEFT(FATURA_PC,14)) num_nf,
				
					(select top 1 ref_acesso_nf_mem from cta_cte_mas_exp_mar where num_proc_mem = LEFT(FATURA_PC,14)) [Site],					
					Repasse_TX
					,p2.Nome_Raz_Soc as [Shipper] -- Alessandra 04/09/2019 - Ticket 100-155779
				FROM
					FATURA_CHB FAT with(nolock)
					JOIN FATURA_CHB_ITEM ITM with(nolock) ON ITM.FATURA_CC=FAT.FATURA_PC
					JOIN PESSOA PP with(nolock) ON PP.CD_PES=CD_PES_PC
					LEFT Join Endereco ED with(nolock) on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
					LEFT JOIN MASTER_EXP_mar MAS with(nolock) ON MAS.NUM_PROC_mem=LEFT(FATURA_PC,14)
					--LEFT join cta_cte_mas_exp_mar CCM on CCM.num_proc_mem = LEFT(FATURA_PC,14) and CCM.NUM_NF_MeM IS NOT NULL AND CCM.REF_ACESSO_NF_MeM <> 'P' AND CCM.REF_ACESSO_NF_MEM is not null
					join Tipo_Taxa TT with(nolock) on TT.cd_tp_Tx=itm.cd_tp_Tx
					LEft Join PO_Master PO with(nolock)on lefT(fat.fatura_pc,14)=po.num_proC_Master AND ID_DC = 1
					Join Localidade Org with(nolock) on Org.cd_local=cd_org_mem
					Join  Localidade dst with(nolock) on dst.cd_local=cd_dst_mem
					left join Pessoa CNS with(nolock) on CNS.cd_pes = MAS.cd_export_mem
					Left Join Campo_Processo CP with(nolock)on CP.Num_Proc=left(@Fatura_PC,14) and Id_Campo=25
					Left Join Localidade LDE with(nolock) on LDE.cd_local=CP.Campo_Dados
					Left Join Fatura with(nolock)on fatcod=fatura_pc
					left join vwClienteALLJOBS vv with(nolock) on vv.num_proc=processo_pc -- Alessandra 04/09/2019 - Ticket 100-155779
					left join Pessoa p2 with(nolock) on  vv.cd_fornecedor = p2.cd_pes -- Alessandra 04/09/2019 - Ticket 100-155779

				where 
					FATURA_PC=@FATURA_PC --and IMPrime='S'
				group by 
					MAS.Num_Proc_MEM,Data_PC,fatDtVenc,obs_PC,obs_mem,right(pp.Num_CPF_CNPJ,14), Fatura_PC,pp.Apelido,pp.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,Mawb_mem ,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, CNS.Nome_Raz_Soc, LDE.Nome_Local
					,Repasse_TX,p2.Nome_Raz_Soc  -- Alessandra 04/09/2019 - Ticket 100-155779 
			END
			
		IF left(@fatura_pc,2)='IM' and (len(@Fatura_PC) = 15 OR len(@Fatura_PC) = 14)
			BEGIN
				SELECT Top 1
					Data_PC,fatDtVenc,obs_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ, Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,
					RUA,Numero,Cidade,UF,max(Numero_PO) Referencia_Cliente,DI_RE_PC,org.nome_local Origem, 
					dst.nome_local Destino,Mawb_mim HOUSE,NULL CD_TP_TX,NULL NOME_TP_TX,NULL VLR_PC, TP_PGTO, Obs_mim OBS_MAS, 
					CNS.Nome_Raz_Soc CNS, LDE.Nome_Local Local_Desemb, 
					dbo.fBusca_Tarefa(MAS.Num_Proc_MIM,4) Dt_Desembaraco,
--					Data_PC,fatDtVenc Vencimento,
					--max(CCM.NUM_NF_MIM) num_nf
					(select max(num_nf_mim) from cta_cte_mas_imp_mar where num_proc_mim = LEFT(FATURA_PC,14)) num_nf,

					(select top 1 ref_acesso_nf_mim from cta_cte_mas_imp_mar where num_proc_mim = LEFT(FATURA_PC,14)) [Site],					
					Repasse_TX
					,p2.Nome_Raz_Soc as [Shipper] -- Alessandra 04/09/2019 - Ticket 100-155779
				FROM 
					FATURA_CHB FAT with(nolock)
					JOIN FATURA_CHB_ITEM ITM with(nolock)ON ITM.FATURA_CC=FAT.FATURA_PC
					JOIN PESSOA PP with(nolock)ON PP.CD_PES=CD_PES_PC
					LEFT Join Endereco ED with(nolock)on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
					LEFT JOIN MASTER_imp_mar MAS with(nolock) ON MAS.NUM_PROC_mim=LEFT(FATURA_PC,14)
					--LEFT join cta_cte_mas_imp_mar CCM on CCM.num_proc_mim = LEFT(FATURA_PC,14) and CCM.NUM_NF_MIM IS NOT NULL AND CCM.REF_ACESSO_NF_MIM <> 'P' AND CCM.REF_ACESSO_NF_MIM is not null
					join Tipo_Taxa TT with(nolock) on TT.cd_tp_Tx=itm.cd_tp_Tx
					LEft Join PO_Master PO with(nolock) on lefT(fat.fatura_pc,14)=po.num_proC_Master AND ID_DC = 1
					Join Localidade Org with(nolock) on Org.cd_local=cd_org_mim
					Join  Localidade dst with(nolock) on dst.cd_local=cd_dst_mim
					left join Pessoa CNS with(nolock) on CNS.cd_pes = MAS.cd_consig_mim
					Left Join Campo_Processo CP with(nolock) on CP.Num_Proc=left(@Fatura_PC,14) and Id_Campo=25
					Left Join Localidade LDE with(nolock) on LDE.cd_local=CP.Campo_Dados
					Left Join Fatura with(nolock) on fatcod=fatura_pc
					left join vwClienteALLJOBS vv with(nolock) on vv.num_proc=processo_pc -- Alessandra 04/09/2019 - Ticket 100-155779
					left join Pessoa p2 with(nolock) on  vv.cd_fornecedor = p2.cd_pes -- Alessandra 04/09/2019 - Ticket 100-155779

				where 
					FATURA_PC=@FATURA_PC --and IMPrime='S'
				group by 
					MAS.Num_Proc_MIM,Data_PC,fatDtVenc,obs_PC,obs_mim,right(pp.Num_CPF_CNPJ,14), Fatura_PC,pp.Apelido,pp.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,Mawb_mim ,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, CNS.Nome_Raz_Soc, LDE.Nome_Local--,NUM_NF_MIM
					,Repasse_TX,p2.Nome_Raz_Soc  -- Alessandra 04/09/2019 - Ticket 100-155779 
			END
			
		IF left(@fatura_pc,2)='IA' and (len(@Fatura_PC) = 15 or len(@fatura_pc)=14)
			BEGIN
				SELECT Top 1
					Data_PC,fatDtVenc,obs_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ, Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,
					RUA,Numero,Cidade,UF,max(Numero_PO) Referencia_Cliente,DI_RE_PC,org.nome_local Origem, 
					dst.nome_local Destino,Mawb_mia HOUSE,NULL CD_TP_TX,NULL NOME_TP_TX,NULL VLR_PC, TP_PGTO, Obs_mia OBS_MAS, 
					CNS.Nome_Raz_Soc CNS, LDE.Nome_Local Local_Desemb,
					dbo.fBusca_Tarefa(MAS.Num_Proc_MIA,4) Dt_Desembaraco,
--					Data_PC,fatDtVenc Vencimento,
--					max(CCM.NUM_NF_MIA) num_nf
					(select max(num_nf_mia) from cta_cte_mas_imp_aer where num_proc_mia = LEFT(FATURA_PC,14)) num_nf,

					(select top 1 ref_acesso_nf_mia from cta_cte_mas_imp_aer where num_proc_mia = LEFT(FATURA_PC,14)) [Site],					
					Repasse_TX
					,p2.Nome_Raz_Soc as [Shipper] -- Alessandra 04/09/2019 - Ticket 100-155779
				FROM 
					FATURA_CHB FAT with(nolock)
					JOIN FATURA_CHB_ITEM ITM with(nolock) ON ITM.FATURA_CC=FAT.FATURA_PC
					JOIN PESSOA PP with(nolock) ON PP.CD_PES=CD_PES_PC
					LEFT Join Endereco ED with(nolock) on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
					LEFT JOIN MASTER_imp_aer MAS with(nolock) ON MAS.NUM_PROC_mia=LEFT(FATURA_PC,14)
					--LEFT join cta_cte_mas_imp_AER CCM on CCM.num_proc_miA = LEFT(FATURA_PC,14) and CCM.NUM_NF_MIA IS NOT NULL AND CCM.REF_ACESSO_NF_MIA <> 'P' AND CCM.REF_ACESSO_NF_MIA is not null
					join Tipo_Taxa TT with(nolock) on TT.cd_tp_Tx=itm.cd_tp_Tx
					LEft Join PO_Master PO with(nolock) on lefT(fat.fatura_pc,14)=po.num_proC_Master AND ID_DC = 1
					Join Localidade Org with(nolock) on Org.cd_local=cd_org_mia
					Join  Localidade dst with(nolock)on dst.cd_local=cd_dst_mia
					left join Pessoa CNS with(nolock) on CNS.cd_pes = MAS.cd_consig_mia
					Left Join Campo_Processo CP with(nolock) on CP.Num_Proc=left(@Fatura_PC,14) and Id_Campo=25
					Left Join Localidade LDE with(nolock) on LDE.cd_local=CP.Campo_Dados
					Left Join Fatura with(nolock) on fatcod=fatura_pc
					left join vwClienteALLJOBS vv with(nolock) on vv.num_proc=processo_pc -- Alessandra 04/09/2019 - Ticket 100-155779
					left join Pessoa p2 with(nolock) on  vv.cd_fornecedor = p2.cd_pes -- Alessandra 04/09/2019 - Ticket 100-155779

				where 
					FATURA_PC=@FATURA_PC --and IMPrime='S'
				group by 
					MAS.Num_Proc_MIA,Data_PC,fatDtVenc,obs_PC,obs_mia,right(pp.Num_CPF_CNPJ,14), Fatura_PC,pp.Apelido,pp.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,Mawb_mia ,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, CNS.Nome_Raz_Soc, LDE.Nome_Local--NUM_NF_MIA
					,Repasse_TX,p2.Nome_Raz_Soc  -- Alessandra 04/09/2019 - Ticket 100-155779 
			END
		end
		
ELSE
	BEGIN
		IF left(@fatura_pc,2)='BO' and (len(@fatura_pc)=17 or len(@fatura_pc)=16)
		BEGIN
			SELECT 
				Data_PC,fatDtVenc,OBS_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ, Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,
				RUA,Numero,Cidade,UF,max(Numero_PO_HBO) Referencia_Cliente,DI_RE_PC,
				'' Origem, 
				'' Destino,
				'' House,
				ITM.CD_TP_TX,
				CASE
					WHEN cast(DP.Cd_Dst as varchar(100)) is null then NOME_TP_TX 
					else 
					cast(DP.Cd_Dst as varchar(100))
					end as NOME_TP_TX,
				VLR_PC, TP_PGTO, 
				Fat.Obs_PC OBS_HOU, 
				CNS.Nome_Raz_Soc CNS, LDE.Nome_Local Local_Desemb,
				dbo.fBusca_Tarefa(HOU.Num_Proc_HBO,4) Dt_Desembaraco,
--					Data_PC,fatDtVenc Vencimento,
				MAX(CCH.Num_NF_HBO) num_nf,
				 
				max(isnull(CCH.Ref_Acesso_NF_HBO,'')) [Site],
				Repasse_TX 
				,[dbo].[fBusca_Docs_PO_Modal](LEFT(FATURA_PC,16),19) Num_Proc_HBO -- Antonio 100-386207 - Ao fechar os jobs (BOS) estão com erro, tipo de taxas 
				,p2.Nome_Raz_Soc as [Shipper] -- Alessandra 04/09/2019 - Ticket 100-155779
			FROM 
				FATURA_CHB FAT with(nolock)
				JOIN FATURA_CHB_ITEM ITM with(nolock) ON ITM.FATURA_CC=FAT.FATURA_PC
				JOIN PESSOA PP with(nolock) ON PP.CD_PES=CD_PES_PC
				JOIN Pessoa_LLP PLLP ON PP.Cd_Pes = PLLP.Cd_Pes -- - Kaique 18/12/2025 - Ticket 100-538694
				LEFT Join Endereco ED with(nolock) on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
				LEFT JOIN House_BDP_OUT HOU with(nolock) ON HOU.Num_Proc_HBO=LEFT(FATURA_PC,16)
				LEFT JOIN Cta_Cte_HOU_BDP_OUT CCH with(nolock) on CCH.Num_Proc_HBO = LEFT(FATURA_PC,16) and CCH.Num_NF_HBO is not null AND CCH.Ref_Acesso_NF_HBO <> 'P' AND CCH.Ref_Acesso_NF_HBO is not null and cch.cd_tp_tx = ITM.cd_tp_tx
				join Tipo_Taxa TT with(nolock) on TT.cd_tp_Tx=itm.cd_tp_Tx
				LEft Join PO_HBO PO with(nolock) on lefT(fat.fatura_pc,16)=po.Num_Proc_HBO AND ID_DC = 1
				--Join Localidade Org with(nolock) on Org.cd_local=cd_org_him
				--Join Localidade dst with(nolock) on dst.cd_local=cd_dst_him
				left join Pessoa CNS with(nolock) on CNS.cd_pes = HOU.cd_cliente_HBO
				Left Join Campo_Processo CP with(nolock) on CP.Num_Proc=left(@Fatura_PC,16) and Id_Campo=25
				Left Join Localidade LDE with(nolock) on LDE.cd_local=CP.Campo_Dados
				Left Join Fatura with(nolock) on fatcod=fatura_pc
				left join vwClienteALLJOBS vv with(nolock) on vv.num_proc=processo_pc -- Alessandra 04/09/2019 - Ticket 100-155779
				left join Pessoa p2 with(nolock) on  vv.cd_fornecedor = p2.cd_pes -- Alessandra 04/09/2019 - Ticket 100-155779
				left join DE_PARA DP with(nolock) on DP.Cd_Org = TT.Cd_Tp_Tx and DP.Cd_Cliente = PLLP.Cd_Pes_Grupo and DP.Cd_Tipo = 38-- -- Kaique 18/12/2025 - Ticket 100-538694
			WHERE 
				FATURA_PC=@FATURA_PC 
			group by 
				HOU.Num_Proc_HBO,Data_PC,fatDtVenc,Obs_PC,fat.Obs_PC,right(pp.Num_CPF_CNPJ,14), 
				Fatura_PC,pp.Apelido,pp.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,
				--org.nome_local , dst.nome_local ,hawb_him ,
				ITM.CD_TP_TX,DP.Cd_Dst,NOME_TP_TX,VLR_PC, TP_PGTO, CNS.Nome_Raz_Soc, LDE.Nome_Local
				,Repasse_TX,p2.Nome_Raz_Soc  -- Alessandra 04/09/2019 - Ticket 100-155779 
		End	
	
		IF left(@fatura_pc,2)='IM' and (len(@fatura_pc)=17 or len(@fatura_pc)=16)
			BEGIN
--Transportation
		SELECT 
				Distinct
				Data_PC,F.fatDtVenc,OBS_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ ,Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,
				RUA,Numero,Cidade,UF,max(Numero_PO_HIM) Referencia_Cliente,DI_RE_PC,org.nome_local Origem, 
				dst.nome_local Destino,hawb_HIM House,IFT.CD_TP_TX,
				CASE
				WHEN cast(DP.Cd_Dst as varchar(100)) is null then NOME_TP_TX + ' ('+ @fatcod + ')'
				else 
				cast(DP.Cd_Dst as varchar(100))  + ' ('+ @fatcod + ')'
				end as NOME_TP_TX,
				IFT.Vlr_RS VLR_PC, 'B' TP_PGTO, Obs_HIM OBS_HOU, 
				CNS.Nome_Raz_Soc CNS, LDE.Nome_Local Local_Desemb,
				dbo.fBusca_Tarefa(HOU.Num_Proc_HIM,4) Dt_Desembaraco,
--				fatDtVenc Vencimento,
				max(CCH.num_nf_HIM) num_nf,				 
				max(isnull(CCH.ref_acesso_nf_HIM,'')) [Site],
				Repasse_TX  
				,p2.Nome_Raz_Soc as [Shipper] -- Alessandra 04/09/2019 - Ticket 100-155779
			FROM 
				FATURA_CHB FAT with(nolock)
				JOIN FATURA_CHB_ITEM ITM with(nolock) ON ITM.FATURA_CC=FAT.FATURA_PC
				Join Fatura FT with(nolock)on FT.fatcod=@fatcod
				Join Item_Fat IFT with(nolock)on FT.fatcod = IFT.FatCod
				JOIN PESSOA PP with(nolock) ON PP.CD_PES=CD_PES_PC
				JOIN Pessoa_LLP PLLP ON PP.Cd_Pes = PLLP.Cd_Pes -- - Kaique 18/12/2025 - Ticket 100-538694
				LEFT Join Endereco ED with(nolock) on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
				LEFT JOIN HOUSE_IMP_MAR HOU with(nolock) ON HOU.NUM_PROC_HIM=LEFT(FATURA_PC,16)
				JOIN cta_cte_hou_IMP_MAR CCH with(nolock) on CCH.num_proc_HIM = LEFT(FATURA_PC,16)  and cch.cd_tp_tx = IFT.cd_tp_tx
				join Tipo_Taxa TT with(nolock) on TT.cd_tp_Tx=IFT.cd_tp_Tx
				LEft Join PO_HIM PO with(nolock) on lefT(fat.fatura_pc,16)=po.num_proC_HIM AND ID_DC = 1
				Join Localidade Org with(nolock) on Org.cd_local=cd_org_HIM
				Join Localidade dst with(nolock) on dst.cd_local=cd_dst_HIM
				left join Pessoa CNS with(nolock) on CNS.cd_pes = HOU.cd_consig_HIM
				Left Join Campo_Processo CP with(nolock) on CP.Num_Proc=left(FATURA_PC,16) and Id_Campo=25
				Left Join Localidade LDE with(nolock) on LDE.cd_local=CP.Campo_Dados
				Left Join Fatura F with(nolock)on F.fatcod=fatura_pc
				left join vwClienteALLJOBS vv with(nolock) on vv.num_proc=processo_pc -- Alessandra 04/09/2019 - Ticket 100-155779
				left join Pessoa p2 with(nolock) on  vv.cd_fornecedor = p2.cd_pes -- Alessandra 04/09/2019 - Ticket 100-155779
				left join DE_PARA DP with(nolock) on DP.Cd_Org = TT.Cd_Tp_Tx and DP.Cd_Cliente = PLLP.Cd_Pes_Grupo and DP.Cd_Tipo = 38-- -- Kaique 18/12/2025 - Ticket 100-538694

			WHERE 
				FATURA_PC=@Fatura_PC
			group by 
				HOU.Num_Proc_HIM,Data_PC,F.fatDtVenc,Obs_PC,obs_HIM,right(pp.Num_CPF_CNPJ,14),Fatura_PC,pp.Apelido,
				pp.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,hawb_HIM ,IFT.CD_TP_TX,
				DP.Cd_Dst, NOME_TP_TX,IFT.Vlr_RS, CNS.Nome_Raz_Soc, LDE.Nome_Local,Repasse_TX,p2.Nome_Raz_Soc  -- Alessandra 04/09/2019 - Ticket 100-155779
		union all
				SELECT 
					Data_PC,fatDtVenc,OBS_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ, Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,
					RUA,Numero,Cidade,UF,max(Numero_PO_HIM) Referencia_Cliente,DI_RE_PC,org.nome_local Origem, 
					dst.nome_local Destino,hawb_him House,ITM.CD_TP_TX,
					CASE
					WHEN cast(DP.Cd_Dst as varchar(100)) is null then NOME_TP_TX 
					else 
					cast(DP.Cd_Dst as varchar(100))
					end as NOME_TP_TX,
					VLR_PC, TP_PGTO, Obs_him OBS_HOU, 
					CNS.Nome_Raz_Soc CNS, LDE.Nome_Local Local_Desemb,
					dbo.fBusca_Tarefa(HOU.Num_Proc_HIM,4) Dt_Desembaraco,
--					Data_PC,fatDtVenc Vencimento,
					MAX(CCH.NUM_NF_HIM) num_nf,
					 
					max(isnull(CCH.ref_acesso_nf_him,'')) [Site],
					Repasse_TX 
					,p2.Nome_Raz_Soc as [Shipper] -- Alessandra 04/09/2019 - Ticket 100-155779
				FROM 
					FATURA_CHB FAT with(nolock)
					JOIN FATURA_CHB_ITEM ITM with(nolock) ON ITM.FATURA_CC=FAT.FATURA_PC
					JOIN PESSOA PP with(nolock) ON PP.CD_PES=CD_PES_PC
					JOIN Pessoa_LLP PLLP ON PP.Cd_Pes = PLLP.Cd_Pes -- - Kaique 18/12/2025 - Ticket 100-538694
					LEFT Join Endereco ED with(nolock) on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
					LEFT JOIN HOUSE_IMP_MAR HOU with(nolock) ON HOU.NUM_PROC_HIM=LEFT(FATURA_PC,16)
					LEFT JOIN cta_cte_hou_imp_mar CCH with(nolock) on CCH.num_proc_him = LEFT(FATURA_PC,16) and CCH.num_nf_him is not null AND CCH.REF_ACESSO_NF_HIM <> 'P' AND CCH.REF_ACESSO_NF_Him is not null and cch.cd_tp_tx = ITM.cd_tp_tx
					join Tipo_Taxa TT with(nolock) on TT.cd_tp_Tx=itm.cd_tp_Tx
					LEft Join PO_HIM PO with(nolock) on lefT(fat.fatura_pc,16)=po.num_proC_him AND ID_DC = 1
					Join Localidade Org with(nolock) on Org.cd_local=cd_org_him
					Join Localidade dst with(nolock) on dst.cd_local=cd_dst_him
					left join Pessoa CNS with(nolock) on CNS.cd_pes = HOU.cd_consig_HIM
					Left Join Campo_Processo CP with(nolock) on CP.Num_Proc=left(@Fatura_PC,16) and Id_Campo=25
					Left Join Localidade LDE with(nolock) on LDE.cd_local=CP.Campo_Dados
					Left Join Fatura with(nolock) on fatcod=fatura_pc
					left join vwClienteALLJOBS vv with(nolock) on vv.num_proc=processo_pc -- Alessandra 04/09/2019 - Ticket 100-155779
					left join Pessoa p2 with(nolock) on  vv.cd_fornecedor = p2.cd_pes -- Alessandra 04/09/2019 - Ticket 100-155779
					left join DE_PARA DP with(nolock) on DP.Cd_Org = TT.Cd_Tp_Tx and DP.Cd_Cliente = PLLP.Cd_Pes_Grupo and DP.Cd_Tipo = 38-- -- Kaique 18/12/2025 - Ticket 100-538694

				WHERE 
					FATURA_PC=@FATURA_PC 
				group by 
					HOU.Num_Proc_HIM,Data_PC,fatDtVenc,Obs_PC,obs_him,right(pp.Num_CPF_CNPJ,14), Fatura_PC,pp.Apelido,pp.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,hawb_him ,ITM.CD_TP_TX,DP.Cd_Dst,NOME_TP_TX,VLR_PC, TP_PGTO, CNS.Nome_Raz_Soc, LDE.Nome_Local
					,Repasse_TX,p2.Nome_Raz_Soc  -- Alessandra 04/09/2019 - Ticket 100-155779 
			End

		IF left(@fatura_pc,2)='IA' and (len(@fatura_pc)=17 or len(@fatura_pc)=16)
			BEGIN
--Transportation
		SELECT 
				Distinct
				Data_PC,F.fatDtVenc,OBS_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ ,Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,
				RUA,Numero,Cidade,UF,max(Numero_PO_HIA) Referencia_Cliente,DI_RE_PC,org.nome_local Origem, 
				dst.nome_local Destino,hawb_HIA House,IFT.CD_TP_TX,
				CASE
				WHEN cast(DP.Cd_Dst as varchar(100)) is null then NOME_TP_TX + ' ('+ @fatcod + ')'
				else 
				cast(DP.Cd_Dst as varchar(100))  + ' ('+ @fatcod + ')'
				end as NOME_TP_TX,
				IFT.Vlr_RS VLR_PC, 'B' TP_PGTO, Obs_HIA OBS_HOU, 
				CNS.Nome_Raz_Soc CNS, LDE.Nome_Local Local_Desemb,
				dbo.fBusca_Tarefa(HOU.Num_Proc_HIA,4) Dt_Desembaraco,
--				fatDtVenc Vencimento,
				max(CCH.num_nf_HIA) num_nf,				 
				max(isnull(CCH.ref_acesso_nf_HIA,'')) [Site],
				Repasse_TX  
				,p2.Nome_Raz_Soc as [Shipper] -- Alessandra 04/09/2019 - Ticket 100-155779
			FROM 
				FATURA_CHB FAT with(nolock)
				JOIN FATURA_CHB_ITEM ITM with(nolock) ON ITM.FATURA_CC=FAT.FATURA_PC
				Join Fatura FT with(nolock)on FT.fatcod=@fatcod
				Join Item_Fat IFT with(nolock)on FT.fatcod = IFT.FatCod
				JOIN PESSOA PP with(nolock) ON PP.CD_PES=CD_PES_PC
				JOIN Pessoa_LLP PLLP ON PP.Cd_Pes = PLLP.Cd_Pes -- - Kaique 18/12/2025 - Ticket 100-538694
				LEFT Join Endereco ED with(nolock) on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
				LEFT JOIN HOUSE_IMP_AER HOU with(nolock) ON HOU.NUM_PROC_HIA=LEFT(FATURA_PC,16)
				JOIN cta_cte_hou_IMP_AER CCH with(nolock) on CCH.num_proc_HIA = LEFT(FATURA_PC,16)  and cch.cd_tp_tx = IFT.cd_tp_tx
				join Tipo_Taxa TT with(nolock) on TT.cd_tp_Tx=IFT.cd_tp_Tx
				LEft Join PO_HIA PO with(nolock) on lefT(fat.fatura_pc,16)=po.num_proC_HIA AND ID_DC = 1
				Join Localidade Org with(nolock) on Org.cd_local=cd_org_HIA
				Join Localidade dst with(nolock) on dst.cd_local=cd_dst_HIA
				left join Pessoa CNS with(nolock) on CNS.cd_pes = HOU.cd_consig_HIA
				Left Join Campo_Processo CP with(nolock) on CP.Num_Proc=left(FATURA_PC,16) and Id_Campo=25
				Left Join Localidade LDE with(nolock) on LDE.cd_local=CP.Campo_Dados
				Left Join Fatura F with(nolock)on F.fatcod=fatura_pc
				left join vwClienteALLJOBS vv with(nolock) on vv.num_proc=processo_pc -- Alessandra 04/09/2019 - Ticket 100-155779
				left join Pessoa p2 with(nolock) on  vv.cd_fornecedor = p2.cd_pes -- Alessandra 04/09/2019 - Ticket 100-155779
				left join DE_PARA DP with(nolock) on DP.Cd_Org = TT.Cd_Tp_Tx and DP.Cd_Cliente = PLLP.Cd_Pes_Grupo and DP.Cd_Tipo = 38-- -- Kaique 18/12/2025 - Ticket 100-538694


			WHERE 
				FATURA_PC=@Fatura_PC
			group by 
				HOU.Num_Proc_HIA,Data_PC,F.fatDtVenc,Obs_PC,obs_HIA,right(pp.Num_CPF_CNPJ,14),Fatura_PC,pp.Apelido,
				pp.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,hawb_HIA ,IFT.CD_TP_TX,
				NOME_TP_TX,DP.Cd_Dst,IFT.Vlr_RS, CNS.Nome_Raz_Soc, LDE.Nome_Local,Repasse_TX,p2.Nome_Raz_Soc  -- Alessandra 04/09/2019 - Ticket 100-155779
		union all
				SELECT 
					Data_PC,null fatDtVenc,Obs_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ, Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,
					RUA,Numero,Cidade,UF,max(Numero_PO_hia) Referencia_Cliente,DI_RE_PC,org.nome_local Origem, 
					dst.nome_local Destino,hawb_hia House,ITM.CD_TP_TX,
					CASE
					WHEN cast(DP.Cd_Dst as varchar(100)) is null then NOME_TP_TX 
					else 
					cast(DP.Cd_Dst as varchar(100))
					end as NOME_TP_TX,
					VLR_PC, TP_PGTO, Obs_hia OBS_HOU, 
					CNS.Nome_Raz_Soc CNS, LDE.Nome_Local Local_Desemb,
					dbo.fBusca_Tarefa(HOU.Num_Proc_HIA,4) Dt_Desembaraco,
--					Data_PC,fatDtVenc Vencimento,
					max(CCH.num_nf_hia) num_nf,

					max(isnull(CCH.ref_acesso_nf_hia,'')) [Site],
					Repasse_TX 
					,p2.Nome_Raz_Soc as [Shipper] -- Alessandra 04/09/2019 - Ticket 100-155779
				FROM 
					FATURA_CHB FAT
					JOIN FATURA_CHB_ITEM ITM with(nolock) ON ITM.FATURA_CC=FAT.FATURA_PC
					JOIN PESSOA PP with(nolock)ON PP.CD_PES=CD_PES_PC
					JOIN Pessoa_LLP PLLP ON PP.Cd_Pes = PLLP.Cd_Pes -- - Kaique 18/12/2025 - Ticket 100-538694
					LEFT Join Endereco ED with(nolock)on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
					LEFT JOIN HOUSE_IMP_aer HOU with(nolock)ON HOU.NUM_PROC_hia=LEFT(FATURA_PC,16)
					LEFT JOIN cta_cte_hou_imp_aer CCH with(nolock)on CCH.num_proc_hia = LEFT(FATURA_PC,16) and CCH.num_nf_hia is not null AND CCH.REF_ACESSO_NF_HIa <> 'P' AND CCH.REF_ACESSO_NF_Hia is not null and cch.cd_tp_tx = ITM.cd_tp_tx
					join Tipo_Taxa TT with(nolock)on TT.cd_tp_Tx=itm.cd_tp_Tx
					LEft Join PO_hia PO with(nolock)on lefT(fat.fatura_pc,16)=po.num_proC_hia AND ID_DC=1
					Left Join Localidade Org with(nolock)on Org.cd_local=cd_org_hia
					Left Join Localidade dst with(nolock)on dst.cd_local=cd_dst_hia
					left join Pessoa CNS with(nolock)on CNS.cd_pes = HOU.cd_consig_HIA
					Left Join Campo_Processo CP with(nolock)on CP.Num_Proc=left(@Fatura_PC,16) and Id_Campo=25
					Left Join Localidade LDE with(nolock)on LDE.cd_local=CP.Campo_Dados
					left join vwClienteALLJOBS vv with(nolock) on vv.num_proc=processo_pc -- Alessandra 04/09/2019 - Ticket 100-155779
					left join Pessoa p2 with(nolock) on  vv.cd_fornecedor = p2.cd_pes -- Alessandra 04/09/2019 - Ticket 100-155779
					left join DE_PARA DP with(nolock) on DP.Cd_Org = TT.Cd_Tp_Tx and DP.Cd_Cliente = PLLP.Cd_Pes_Grupo and DP.Cd_Tipo = 38-- -- Kaique 18/12/2025 - Ticket 100-538694

				WHERE 
					FATURA_PC=@FATURA_PC 
				group by 
					HOU.Num_Proc_HIA,Data_PC,Obs_PC,obs_hia,right(pp.Num_CPF_CNPJ,14), Fatura_PC,pp.Apelido,pp.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,hawb_hia ,ITM.CD_TP_TX,NOME_TP_TX,DP.Cd_Dst,VLR_PC, TP_PGTO, CNS.Nome_Raz_Soc, LDE.Nome_Local
					,Repasse_TX,Repasse_TX,p2.Nome_Raz_Soc  -- Alessandra 04/09/2019 - Ticket 100-155779
		 
			END
		
		IF left(@fatura_pc,2)='EM' and (len(@fatura_pc)=17 or len(@fatura_pc)=16)
			BEGIN
			--Transportation
		SELECT 
				Distinct
				Data_PC,F.fatDtVenc,OBS_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ ,Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,
				RUA,Numero,Cidade,UF,max(Numero_PO_HEM) Referencia_Cliente,DI_RE_PC,org.nome_local Origem, 
				dst.nome_local Destino,hawb_HEM House,IFT.CD_TP_TX,
				CASE
				WHEN cast(DP.Cd_Dst as varchar(100)) is null then NOME_TP_TX + ' ('+ @fatcod + ')' 
				else 
				cast(DP.Cd_Dst as varchar(100)) + ' ('+ @fatcod + ')' 
				end as NOME_TP_TX,
				IFT.Vlr_RS VLR_PC, 'B' TP_PGTO, Obs_HEM OBS_HOU, 
				CNS.Nome_Raz_Soc CNS, LDE.Nome_Local Local_Desemb,
				dbo.fBusca_Tarefa(HOU.Num_Proc_HEM,4) Dt_Desembaraco,
--				fatDtVenc Vencimento,
				max(CCH.num_nf_HEM) num_nf,				 
				max(isnull(CCH.ref_acesso_nf_HEM,'')) [Site],
				Repasse_TX  
				,p2.Nome_Raz_Soc as [Shipper] -- Alessandra 04/09/2019 - Ticket 100-155779
			FROM 
				FATURA_CHB FAT with(nolock)
				JOIN FATURA_CHB_ITEM ITM with(nolock) ON ITM.FATURA_CC=FAT.FATURA_PC
				Join Fatura FT with(nolock)on FT.fatcod=@fatcod
				Join Item_Fat IFT with(nolock)on FT.fatcod = IFT.FatCod
				JOIN PESSOA PP with(nolock) ON PP.CD_PES=CD_PES_PC
				JOIN Pessoa_LLP PLLP ON PP.Cd_Pes = PLLP.Cd_Pes -- - Kaique 18/12/2025 - Ticket 100-538694
				LEFT Join Endereco ED with(nolock) on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
				LEFT JOIN HOUSE_EXP_MAR HOU with(nolock) ON HOU.NUM_PROC_HEM=LEFT(FATURA_PC,16)
				JOIN cta_cte_hou_EXP_MAR CCH with(nolock) on CCH.num_proc_HEM = LEFT(FATURA_PC,16)  and cch.cd_tp_tx = IFT.cd_tp_tx
				join Tipo_Taxa TT with(nolock) on TT.cd_tp_Tx=IFT.cd_tp_Tx
				LEft Join PO_HEM PO with(nolock) on lefT(fat.fatura_pc,16)=po.num_proC_HEM AND ID_DC = 1
				Join Localidade Org with(nolock) on Org.cd_local=cd_org_HEM
				Join Localidade dst with(nolock) on dst.cd_local=cd_dst_HEM
				left join Pessoa CNS with(nolock) on CNS.cd_pes = HOU.cd_consig_HEM
				Left Join Campo_Processo CP with(nolock) on CP.Num_Proc=left(FATURA_PC,16) and Id_Campo=25
				Left Join Localidade LDE with(nolock) on LDE.cd_local=CP.Campo_Dados
				Left Join Fatura F with(nolock)on F.fatcod=fatura_pc
				left join vwClienteALLJOBS vv with(nolock) on vv.num_proc=processo_pc -- Alessandra 04/09/2019 - Ticket 100-155779
				left join Pessoa p2 with(nolock) on  vv.cd_fornecedor = p2.cd_pes -- Alessandra 04/09/2019 - Ticket 100-155779
				left join DE_PARA DP with(nolock) on DP.Cd_Org = TT.Cd_Tp_Tx and DP.Cd_Cliente = PLLP.Cd_Pes_Grupo and DP.Cd_Tipo = 38 -- Kaique 18/12/2025 - Ticket 100-538694

			WHERE 
				FATURA_PC=@Fatura_PC
			group by 
				HOU.Num_Proc_HEM,Data_PC,F.fatDtVenc,Obs_PC,obs_HEM,right(pp.Num_CPF_CNPJ,14),Fatura_PC,pp.Apelido,
				pp.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,hawb_HEM ,IFT.CD_TP_TX,
				DP.Cd_Dst,NOME_TP_TX,IFT.Vlr_RS, CNS.Nome_Raz_Soc, LDE.Nome_Local,Repasse_TX,p2.Nome_Raz_Soc  -- Alessandra 04/09/2019 - Ticket 100-155779
		union all
				SELECT 
					Data_PC,fatDtVenc,OBS_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ, Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,
					RUA,Numero,Cidade,UF,max(Numero_PO_HEM) Referencia_Cliente,DI_RE_PC,org.nome_local Origem, 
					dst.nome_local Destino,hawb_HEM House,ITM.CD_TP_TX,
					CASE
					WHEN cast(DP.Cd_Dst as varchar(100)) is null then TT.Nome_Tp_Tx
					else 
					cast(DP.Cd_Dst as varchar(100)) 
					end as NOME_TP_TX,
					VLR_PC, TP_PGTO, Obs_hem OBS_HOU, 
					CNS.Nome_raz_Soc CNS, LDE.Nome_Local Local_Desemb,
					dbo.fBusca_Tarefa(HOU.Num_Proc_HEM,4) Dt_Desembaraco ,
--					Data_PC,fatDtVenc Vencimento,
					max(CCH.num_nf_hem) num_nf,

					max(isnull(CCH.ref_acesso_nf_hem,'')) [Site],
					Repasse_TX
					,p2.Nome_Raz_Soc as [Shipper] -- Alessandra 04/09/2019 - Ticket 100-155779
				FROM 
					FATURA_CHB FAT with(nolock)
					JOIN FATURA_CHB_ITEM ITM with(nolock)ON ITM.FATURA_CC=FAT.FATURA_PC
					JOIN PESSOA PP with(nolock)ON PP.CD_PES=CD_PES_PC
					JOIN Pessoa_LLP PLLP ON PP.Cd_Pes = PLLP.Cd_Pes -- - Kaique 18/12/2025 - Ticket 100-538694
					LEFT Join Endereco ED with(nolock)on ED.cd_pes=cd_pes_PC and ED.cd_tp_end='COM'
					LEFT JOIN HOUSE_EXP_MAR HOU with(nolock)ON HOU.NUM_PROC_HEM=LEFT(FATURA_PC,16)
					LEFT JOIN cta_cte_hou_exp_mar CCH with(nolock)on CCH.num_proc_hem = LEFT(FATURA_PC,16) and CCH.num_nf_hem is not null AND CCH.REF_ACESSO_NF_Hem <> 'P' AND CCH.REF_ACESSO_NF_Hem is not null and cch.cd_tp_tx = ITM.cd_tp_tx
					join Tipo_Taxa TT with(nolock)on TT.cd_tp_Tx=itm.cd_tp_Tx
					LEft Join PO_HEM PO with(nolock)on lefT(fat.fatura_pc,16)=po.num_proC_HEM AND ID_DC = 1
					Left Join Localidade Org with(nolock)on Org.cd_local=cd_org_HEM
					Left Join Localidade dst with(nolock)on dst.cd_local=cd_dst_HEM
					left join Pessoa CNS with(nolock)on CNS.cd_pes = HOU.cd_export_HEM
					Left Join Campo_Processo CP with(nolock)on CP.Num_Proc=left(@Fatura_PC,16) and Id_Campo=25
					Left Join Localidade LDE with(nolock)on LDE.cd_local=CP.Campo_Dados
					Left Join Fatura with(nolock)on fatcod=fatura_pc
					left join vwClienteALLJOBS vv with(nolock) on vv.num_proc=processo_pc -- Alessandra 04/09/2019 - Ticket 100-155779
					left join Pessoa p2 with(nolock) on  vv.cd_fornecedor = p2.cd_pes -- Alessandra 04/09/2019 - Ticket 100-155779
					left join DE_PARA DP with(nolock) on DP.Cd_Org = TT.Cd_Tp_Tx and DP.Cd_Cliente = PLLP.Cd_Pes_Grupo and DP.Cd_Tipo = 38-- -- Kaique 18/12/2025 - Ticket 100-538694

					
				WHERE 
					FATURA_PC=@FATURA_PC
				group by 
					HOU.Num_Proc_HEM,Data_PC,fatDtVenc,OBS_PC,Obs_Hem,right(pp.Num_CPF_CNPJ,14), Fatura_PC,pp.Apelido,pp.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,hawb_HEM ,ITM.CD_TP_TX,DP.Cd_Dst,NOME_TP_TX,VLR_PC, TP_PGTO, CNS.Nome_Raz_Soc, LDE.Nome_Local
					,Repasse_TX ,p2.Nome_Raz_Soc  -- Alessandra 04/09/2019 - Ticket 100-155779
			END

		IF left(@fatura_pc,2)='EA' and (len(@fatura_pc)=17 or len(@fatura_pc)=16)
			BEGIN
			
	--Transportation
		SELECT 
				Distinct
				Data_PC,F.fatDtVenc,OBS_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ ,Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,
				RUA,Numero,Cidade,UF,max(Numero_PO_HEA) Referencia_Cliente,DI_RE_PC,org.nome_local Origem, 
				dst.nome_local Destino,hawb_HEA House,IFT.CD_TP_TX,
				CASE
				WHEN cast(DP.Cd_Dst as varchar(100)) is null then NOME_TP_TX + ' ('+ @fatcod + ')' 
				else 
				cast(DP.Cd_Dst as varchar(100)) + ' ('+ @fatcod + ')' 
				end as NOME_TP_TX,

				IFT.Vlr_RS VLR_PC, 'B' TP_PGTO, Obs_HEA OBS_HOU, 
				CNS.Nome_Raz_Soc CNS, LDE.Nome_Local Local_Desemb,
				dbo.fBusca_Tarefa(HOU.Num_Proc_HEA,4) Dt_Desembaraco,
--				fatDtVenc Vencimento,
				max(CCH.num_nf_HEA) num_nf,				 
				max(isnull(CCH.ref_acesso_nf_HEA,'')) [Site],
				Repasse_TX  
				,p2.Nome_Raz_Soc as [Shipper] -- Alessandra 04/09/2019 - Ticket 100-155779
			FROM 
				FATURA_CHB FAT with(nolock)
				JOIN FATURA_CHB_ITEM ITM with(nolock) ON ITM.FATURA_CC=FAT.FATURA_PC
				Join Fatura FT with(nolock)on FT.fatcod=@fatcod
				Join Item_Fat IFT with(nolock)on FT.fatcod = IFT.FatCod
				JOIN PESSOA PP with(nolock) ON PP.CD_PES=CD_PES_PC
				JOIN Pessoa_LLP PLLP ON PP.Cd_Pes = PLLP.Cd_Pes -- - Kaique 18/12/2025 - Ticket 100-538694
				LEFT Join Endereco ED with(nolock) on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
				LEFT JOIN HOUSE_EXP_AER HOU with(nolock) ON HOU.NUM_PROC_HEA=LEFT(FATURA_PC,16)
				JOIN cta_cte_hou_EXP_AER CCH with(nolock) on CCH.num_proc_HEA = LEFT(FATURA_PC,16)  and cch.cd_tp_tx = IFT.cd_tp_tx
				join Tipo_Taxa TT with(nolock) on TT.cd_tp_Tx=IFT.cd_tp_Tx
				LEft Join PO_HEA PO with(nolock) on lefT(fat.fatura_pc,16)=po.num_proC_HEA AND ID_DC = 1
				Join Localidade Org with(nolock) on Org.cd_local=cd_org_HEA
				Join Localidade dst with(nolock) on dst.cd_local=cd_dst_HEA
				left join Pessoa CNS with(nolock) on CNS.cd_pes = HOU.cd_consig_HEA
				Left Join Campo_Processo CP with(nolock) on CP.Num_Proc=left(FATURA_PC,16) and Id_Campo=25
				Left Join Localidade LDE with(nolock) on LDE.cd_local=CP.Campo_Dados
				Left Join Fatura F with(nolock)on F.fatcod=fatura_pc
				left join vwClienteALLJOBS vv with(nolock) on vv.num_proc=processo_pc -- Alessandra 04/09/2019 - Ticket 100-155779
				left join Pessoa p2 with(nolock) on  vv.cd_fornecedor = p2.cd_pes -- Alessandra 04/09/2019 - Ticket 100-155779
				left join DE_PARA DP with(nolock) on DP.Cd_Org = TT.Cd_Tp_Tx and DP.Cd_Cliente = PLLP.Cd_Pes_Grupo and DP.Cd_Tipo = 38-- -- Kaique 18/12/2025 - Ticket 100-538694


			WHERE 
				FATURA_PC=@Fatura_PC
			group by 
				HOU.Num_Proc_HEA,Data_PC,F.fatDtVenc,Obs_PC,obs_HEA,right(pp.Num_CPF_CNPJ,14),Fatura_PC,pp.Apelido,
				pp.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,hawb_HEA ,IFT.CD_TP_TX,
				DP.Cd_Dst,NOME_TP_TX,IFT.Vlr_RS, CNS.Nome_Raz_Soc, LDE.Nome_Local,Repasse_TX,p2.Nome_Raz_Soc  -- Alessandra 04/09/2019 - Ticket 100-155779
		union all
				SELECT 
					Data_PC,fatDtVenc,obs_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ, Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,
					RUA,Numero,Cidade,UF,max(Numero_PO_HEA) Referencia_Cliente,DI_RE_PC,org.nome_local Origem, 
					dst.nome_local Destino,hawb_HEA House,ITM.CD_TP_TX,	
					CASE
					WHEN cast(DP.Cd_Dst as varchar(100)) is null then TT.Nome_Tp_Tx
					else 
					cast(DP.Cd_Dst as varchar(100)) 
					end as NOME_TP_TX
					,VLR_PC, TP_PGTO, Obs_hea OBS_HOU, 
					CNS.Nome_Raz_Soc CNS, LDE.Nome_Local Local_Desemb,
					dbo.fBusca_Tarefa(HOU.Num_Proc_HEA,4) Dt_Desembaraco,
--					Data_PC,fatDtVenc Vencimento,
					CCH.num_nf_hea num_nf,

					max(isnull(CCH.ref_acesso_nf_hea,'')) [Site],
					Repasse_TX 
					,p2.Nome_Raz_Soc as [Shipper] -- Alessandra 04/09/2019 - Ticket 100-155779
				FROM
					FATURA_CHB FAT with(nolock)
					JOIN FATURA_CHB_ITEM ITM with(nolock)ON ITM.FATURA_CC=FAT.FATURA_PC
					JOIN PESSOA PP with(nolock)ON PP.CD_PES=CD_PES_PC
					JOIN Pessoa_LLP PLLP ON PP.Cd_Pes = PLLP.Cd_Pes -- - Kaique 18/12/2025 - Ticket 100-538694
					LEFT Join Endereco ED with(nolock)on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
					LEFT JOIN HOUSE_EXP_aer HOU with(nolock)ON HOU.NUM_PROC_HEA=LEFT(FATURA_PC,16)
					LEFT JOIN cta_cte_hou_exp_aer CCH with(nolock)on CCH.num_proc_hea = LEFT(FATURA_PC,16) and CCH.num_nf_hea is not null AND CCH.REF_ACESSO_NF_Hea <> 'P' AND CCH.REF_ACESSO_NF_Hea is not null and cch.cd_tp_tx = ITM.cd_tp_tx
					join Tipo_Taxa TT with(nolock)on TT.cd_tp_Tx=itm.cd_tp_Tx
					LEft Join PO_HEA PO with(nolock)on lefT(fat.fatura_pc,16)=po.num_proC_HEA AND ID_DC = 1
					Left Join Localidade Org with(nolock)on Org.cd_local=cd_org_HEA
					Left Join Localidade dst with(nolock)on dst.cd_local=cd_dst_HEA
					left join Pessoa CNS with(nolock)on CNS.cd_pes = HOU.cd_export_HEA
					Left Join Campo_Processo CP with(nolock)on CP.Num_Proc=left(@Fatura_PC,16) and Id_Campo=25
					Left Join Localidade LDE with(nolock)on LDE.cd_local=CP.Campo_Dados
					Left Join Fatura with(nolock)on fatcod=fatura_pc
					left join vwClienteALLJOBS vv with(nolock) on vv.num_proc=processo_pc -- Alessandra 04/09/2019 - Ticket 100-155779
					left join Pessoa p2 with(nolock) on  vv.cd_fornecedor = p2.cd_pes -- Alessandra 04/09/2019 - Ticket 100-155779
					left join DE_PARA DP with(nolock) on DP.Cd_Org = TT.Cd_Tp_Tx and DP.Cd_Cliente = PLLP.Cd_Pes_Grupo and DP.Cd_Tipo = 38-- -- Kaique 18/12/2025 - Ticket 100-538694

				WHERE 
					FATURA_PC=@FATURA_PC
				group by 
					HOU.Num_Proc_HEA,Data_PC,fatDtVenc,obs_PC,obs_hea,right(pp.Num_CPF_CNPJ,14), Fatura_PC,pp.Apelido,pp.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,hawb_HEA ,ITM.CD_TP_TX,DP.Cd_Dst,NOME_TP_TX,VLR_PC, TP_PGTO, CNS.Nome_Raz_Soc, LDE.Nome_Local,CCH.num_nf_hea 
					,Repasse_TX,p2.Nome_Raz_Soc  -- Alessandra 04/09/2019 - Ticket 100-155779 
			END
			
		IF left(@fatura_pc,2)='EO' and (len(@fatura_pc)=17 or len(@fatura_pc)=16)
			BEGIN
--Transportation
		SELECT 
				Distinct
				Data_PC,F.fatDtVenc,OBS_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ ,Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,
				RUA,Numero,Cidade,UF,max(Numero_PO_HEO) Referencia_Cliente,DI_RE_PC,org.nome_local Origem, 
				dst.nome_local Destino,hawb_HEO House,IFT.CD_TP_TX,
				CASE
				WHEN cast(DP.Cd_Dst as varchar(100)) is null then NOME_TP_TX + ' ('+ @fatcod + ')' 
				else 
				cast(DP.Cd_Dst as varchar(100)) + ' ('+ @fatcod + ')' 
				end as NOME_TP_TX,

				IFT.Vlr_RS VLR_PC, 'B' TP_PGTO, Obs_HEO OBS_HOU, 
				CNS.Nome_Raz_Soc CNS, LDE.Nome_Local Local_Desemb,
				dbo.fBusca_Tarefa(HOU.Num_Proc_HEO,4) Dt_Desembaraco,
--				fatDtVenc Vencimento,
				max(CCH.num_nf_HEO) num_nf,				 
				max(isnull(CCH.ref_acesso_nf_HEO,'')) [Site],
				Repasse_TX  
				,p2.Nome_Raz_Soc as [Shipper] -- Alessandra 04/09/2019 - Ticket 100-155779
			FROM 
				FATURA_CHB FAT with(nolock)
				JOIN FATURA_CHB_ITEM ITM with(nolock) ON ITM.FATURA_CC=FAT.FATURA_PC
				Join Fatura FT with(nolock)on FT.fatcod=@fatcod
				Join Item_Fat IFT with(nolock)on FT.fatcod = IFT.FatCod
				JOIN PESSOA PP with(nolock) ON PP.CD_PES=CD_PES_PC
				JOIN Pessoa_LLP PLLP ON PP.Cd_Pes = PLLP.Cd_Pes -- - Kaique 18/12/2025 - Ticket 100-538694
				LEFT Join Endereco ED with(nolock) on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
				LEFT JOIN HOUSE_EXP_OUT HOU with(nolock) ON HOU.NUM_PROC_HEO=LEFT(FATURA_PC,16)
				JOIN cta_cte_hou_EXP_OUT CCH with(nolock) on CCH.num_proc_HEO = LEFT(FATURA_PC,16)  and cch.cd_tp_tx = IFT.cd_tp_tx
				join Tipo_Taxa TT with(nolock) on TT.cd_tp_Tx=IFT.cd_tp_Tx
				LEft Join PO_HEO PO with(nolock) on lefT(fat.fatura_pc,16)=po.num_proC_HEO AND ID_DC = 1
				Join Localidade Org with(nolock) on Org.cd_local=cd_org_HEO
				Join Localidade dst with(nolock) on dst.cd_local=cd_dst_HEO
				left join Pessoa CNS with(nolock) on CNS.cd_pes = HOU.cd_consig_HEO
				Left Join Campo_Processo CP with(nolock) on CP.Num_Proc=left(FATURA_PC,16) and Id_Campo=25
				Left Join Localidade LDE with(nolock) on LDE.cd_local=CP.Campo_Dados
				Left Join Fatura F with(nolock)on F.fatcod=fatura_pc
				left join vwClienteALLJOBS vv with(nolock) on vv.num_proc=processo_pc -- Alessandra 04/09/2019 - Ticket 100-155779
				left join Pessoa p2 with(nolock) on  vv.cd_fornecedor = p2.cd_pes -- Alessandra 04/09/2019 - Ticket 100-155779
				left join DE_PARA DP with(nolock) on DP.Cd_Org = TT.Cd_Tp_Tx and DP.Cd_Cliente = PLLP.Cd_Pes_Grupo and DP.Cd_Tipo = 38-- -- Kaique 18/12/2025 - Ticket 100-538694


			WHERE 
				FATURA_PC=@Fatura_PC
			group by 
				HOU.Num_Proc_HEO,Data_PC,F.fatDtVenc,Obs_PC,obs_HEO,right(pp.Num_CPF_CNPJ,14),Fatura_PC,pp.Apelido,
				pp.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,hawb_HEO ,IFT.CD_TP_TX,
				Nome_Tp_Tx,DP.Cd_Dst,IFT.Vlr_RS, CNS.Nome_Raz_Soc, LDE.Nome_Local,Repasse_TX,p2.Nome_Raz_Soc  -- Alessandra 04/09/2019 - Ticket 100-155779
		union all
				SELECT 
					Data_PC,fatDtVenc,obs_pc OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ, Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,
					RUA,Numero,Cidade,UF,max(Numero_PO_HEO) Referencia_Cliente,DI_RE_PC,org.nome_local Origem, 
					dst.nome_local Destino,hawb_HEO House,ITM.CD_TP_TX,
					CASE
					WHEN cast(DP.Cd_Dst as varchar(100)) is null then TT.Nome_Tp_Tx
					else 
					cast(DP.Cd_Dst as varchar(100)) 
					end as NOME_TP_TX,
					VLR_PC, TP_PGTO, Obs_heo OBS_HOU,
					CNS.Nome_raz_soc CNS, LDE.Nome_Local Local_Desemb,
					dbo.fBusca_Tarefa(HOU.Num_Proc_HEO,4) Dt_Desembaraco,
--					Data_PC, fatDtVenc Vencimento,
					CCH.num_nf_heo num_nf,

					max(isnull(CCH.ref_acesso_nf_heo,'')) [Site],
					Repasse_TX
					,p2.Nome_Raz_Soc as [Shipper] -- Alessandra 04/09/2019 - Ticket 100-155779
				FROM 
					FATURA_CHB FAT with(nolock)
					JOIN FATURA_CHB_ITEM ITM with(nolock)ON ITM.FATURA_CC=FAT.FATURA_PC
					JOIN PESSOA PP with(nolock) ON PP.CD_PES=CD_PES_PC
					JOIN Pessoa_LLP PLLP ON PP.Cd_Pes = PLLP.Cd_Pes -- - Kaique 18/12/2025 - Ticket 100-538694
					LEFT Join Endereco ED with(nolock)on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
					LEFT JOIN HOUSE_EXP_out HOU with(nolock)ON HOU.NUM_PROC_HEO=LEFT(FATURA_PC,16)
					LEFT JOIN cta_cte_hou_exp_out CCH with(nolock)on CCH.num_proc_heo = LEFT(FATURA_PC,16) and CCH.num_nf_heo is not null AND CCH.REF_ACESSO_NF_Heo <> 'P' AND CCH.REF_ACESSO_NF_Heo is not null and cch.cd_tp_tx = ITM.cd_tp_tx
					join Tipo_Taxa TT with(nolock)on TT.cd_tp_Tx=itm.cd_tp_Tx
					LEft Join PO_HEO PO with(nolock)on lefT(fat.fatura_pc,16)=po.num_proC_HEO AND ID_DC = 1
					Left Join Localidade Org with(nolock)on Org.cd_local=cd_org_HEO
					Left Join Localidade dst with(nolock)on dst.cd_local=cd_dst_HEO
					left join Pessoa CNS with(nolock)on CNS.cd_pes = HOU.cd_export_HEO
					Left Join Campo_Processo CP with(nolock)on CP.Num_Proc=left(@Fatura_PC,16) and Id_Campo=25
					Left Join Localidade LDE with(nolock)on LDE.cd_local=CP.Campo_Dados
					Left Join Fatura with(nolock)on fatcod=fatura_pc
					left join vwClienteALLJOBS vv with(nolock) on vv.num_proc=processo_pc -- Alessandra 04/09/2019 - Ticket 100-155779
					left join Pessoa p2 with(nolock) on  vv.cd_fornecedor = p2.cd_pes -- Alessandra 04/09/2019 - Ticket 100-155779
					left join DE_PARA DP with(nolock) on DP.Cd_Org = TT.Cd_Tp_Tx and DP.Cd_Cliente = PLLP.Cd_Pes_Grupo and DP.Cd_Tipo = 38-- -- Kaique 18/12/2025 - Ticket 100-538694

				WHERE 
					FATURA_PC=@FATURA_PC 
				group by 
					HOU.Num_Proc_HEO,Data_PC,fatDtVenc,obs_pc,obs_heo,right(pp.Num_CPF_CNPJ,14), Fatura_PC,pp.Apelido,pp.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,hawb_HEO ,ITM.CD_TP_TX,DP.Cd_Dst,NOME_TP_TX,VLR_PC, TP_PGTO, CNS.Nome_raz_Soc, LDE.Nome_Local,num_nf_heo
					,Repasse_TX,p2.Nome_Raz_Soc  -- Alessandra 04/09/2019 - Ticket 100-155779 
			END

		If left(@fatura_pc,2)='IO' and (len(@Fatura_PC) = 17 or len(@fatura_pc)=16)
			BEGIN
--Transportation
		SELECT 
				Distinct
				Data_PC,F.fatDtVenc,OBS_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ ,Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,
				RUA,Numero,Cidade,UF,max(Numero_PO_HIO) Referencia_Cliente,DI_RE_PC,org.nome_local Origem, 
				dst.nome_local Destino,hawb_HIO House,IFT.CD_TP_TX,
				CASE
				WHEN cast(DP.Cd_Dst as varchar(100)) is null then NOME_TP_TX + ' ('+ @fatcod + ')' 
				else 
				cast(DP.Cd_Dst as varchar(100)) + ' ('+ @fatcod + ')' 
				end as NOME_TP_TX,

				IFT.Vlr_RS VLR_PC, 'B' TP_PGTO, Obs_HIO OBS_HOU, 
				CNS.Nome_Raz_Soc CNS, LDE.Nome_Local Local_Desemb,
				dbo.fBusca_Tarefa(HOU.Num_Proc_HIO,4) Dt_Desembaraco,
--				fatDtVenc Vencimento,
				max(CCH.num_nf_HIO) num_nf,				 
				max(isnull(CCH.ref_acesso_nf_HIO,'')) [Site],
				Repasse_TX  
				,p2.Nome_Raz_Soc as [Shipper] -- Alessandra 04/09/2019 - Ticket 100-155779
			FROM 
				FATURA_CHB FAT with(nolock)
				JOIN FATURA_CHB_ITEM ITM with(nolock) ON ITM.FATURA_CC=FAT.FATURA_PC
				Join Fatura FT with(nolock)on FT.fatcod=@fatcod
				Join Item_Fat IFT with(nolock)on FT.fatcod = IFT.FatCod
				JOIN PESSOA PP with(nolock) ON PP.CD_PES=CD_PES_PC
				JOIN Pessoa_LLP PLLP ON PP.Cd_Pes = PLLP.Cd_Pes -- - Kaique 18/12/2025 - Ticket 100-538694
				LEFT Join Endereco ED with(nolock) on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
				LEFT JOIN HOUSE_IMP_OUT HOU with(nolock) ON HOU.NUM_PROC_HIO=LEFT(FATURA_PC,16)
				JOIN cta_cte_hou_IMP_OUT CCH with(nolock) on CCH.num_proc_HIO = LEFT(FATURA_PC,16)  and cch.cd_tp_tx = IFT.cd_tp_tx
				join Tipo_Taxa TT with(nolock) on TT.cd_tp_Tx=IFT.cd_tp_Tx
				LEft Join PO_HIO PO with(nolock) on lefT(fat.fatura_pc,16)=po.num_proC_HIO AND ID_DC = 1
				Join Localidade Org with(nolock) on Org.cd_local=cd_org_HIO
				Join Localidade dst with(nolock) on dst.cd_local=cd_dst_HIO
				left join Pessoa CNS with(nolock) on CNS.cd_pes = HOU.cd_consig_HIO
				Left Join Campo_Processo CP with(nolock) on CP.Num_Proc=left(FATURA_PC,16) and Id_Campo=25
				Left Join Localidade LDE with(nolock) on LDE.cd_local=CP.Campo_Dados
				Left Join Fatura F with(nolock)on F.fatcod=fatura_pc
				left join vwClienteALLJOBS vv with(nolock) on vv.num_proc=processo_pc -- Alessandra 04/09/2019 - Ticket 100-155779
				left join Pessoa p2 with(nolock) on  vv.cd_fornecedor = p2.cd_pes -- Alessandra 04/09/2019 - Ticket 100-155779
				left join DE_PARA DP with(nolock) on DP.Cd_Org = TT.Cd_Tp_Tx and DP.Cd_Cliente = PLLP.Cd_Pes_Grupo and DP.Cd_Tipo = 38-- -- Kaique 18/12/2025 - Ticket 100-538694
			WHERE 
				FATURA_PC=@Fatura_PC
			group by 
				HOU.Num_Proc_HIO,Data_PC,F.fatDtVenc,Obs_PC,obs_HIO,right(pp.Num_CPF_CNPJ,14),Fatura_PC,pp.Apelido,
				pp.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,hawb_HIO ,IFT.CD_TP_TX,DP.Cd_Dst,
				NOME_TP_TX,IFT.Vlr_RS, CNS.Nome_Raz_Soc, LDE.Nome_Local,Repasse_TX,p2.Nome_Raz_Soc  -- Alessandra 04/09/2019 - Ticket 100-155779
		union all
				SELECT 
					Data_PC,fatDtVenc,obs_pc OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ, Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,
					RUA,Numero,Cidade,UF,max(Numero_PO_HIO) Referencia_Cliente,DI_RE_PC,org.nome_local Origem, 
					dst.nome_local Destino,hawb_HIO House,ITM.CD_TP_TX,
					CASE
					WHEN cast(DP.Cd_Dst as varchar(100)) is null then TT.Nome_Tp_Tx
					else 
					cast(DP.Cd_Dst as varchar(100)) 
					end as NOME_TP_TX,
					VLR_PC, TP_PGTO, Obs_hio OBS_HOU, 
					CNS.Nome_Raz_soc CNS, LDE.Nome_Local Local_Desemb,
					dbo.fBusca_Tarefa(HOU.Num_Proc_HIO,4) Dt_Desembaraco, 
--					Data_PC, fatDtVenc Vencimento, 
					CCH.num_nf_hio num_nf,

					max(isnull(CCH.ref_acesso_nf_hio,'')) [Site],
					Repasse_TX 
					,p2.Nome_Raz_Soc as [Shipper] -- Alessandra 04/09/2019 - Ticket 100-155779
				FROM 
					FATURA_CHB FAT with(nolock)
					JOIN FATURA_CHB_ITEM ITM with(nolock)ON ITM.FATURA_CC=FAT.FATURA_PC
					JOIN PESSOA PP with(nolock)ON PP.CD_PES=CD_PES_PC
					JOIN Pessoa_LLP PLLP ON PP.Cd_Pes = PLLP.Cd_Pes -- - Kaique 18/12/2025 - Ticket 100-538694
					LEFT Join Endereco ED with(nolock)on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
					LEFT JOIN HOUSE_IMP_out HOU with(nolock)ON HOU.NUM_PROC_HIO=LEFT(FATURA_PC,16)
					LEFT JOIN cta_cte_hou_imp_out CCH with(nolock)on CCH.num_proc_hio = LEFT(FATURA_PC,16) and CCH.num_nf_hio is not null AND CCH.REF_ACESSO_NF_Hio <> 'P' AND CCH.REF_ACESSO_NF_Hio is not null and cch.cd_tp_tx = ITM.cd_tp_tx
					join Tipo_Taxa TT with(nolock)on TT.cd_tp_Tx=itm.cd_tp_Tx
					LEft Join PO_HIO PO with(nolock)on lefT(fat.fatura_pc,16)=po.num_proC_HIO AND ID_DC = 1
					Left Join Localidade Org with(nolock)on Org.cd_local=cd_org_HIO
					Left Join Localidade dst with(nolock)on dst.cd_local=cd_dst_HIO
					left join Pessoa CNS with(nolock)on CNS.cd_pes = HOU.cd_consig_HIO
					Left Join Campo_Processo CP with(nolock)on CP.Num_Proc=left(@Fatura_PC,16) and Id_Campo=25
					Left Join Localidade LDE with(nolock)on LDE.cd_local=CP.Campo_Dados
					Left Join Fatura with(nolock)on fatcod=fatura_pc
					left join vwClienteALLJOBS vv with(nolock) on vv.num_proc=processo_pc -- Alessandra 04/09/2019 - Ticket 100-155779
					left join Pessoa p2 with(nolock) on  vv.cd_fornecedor = p2.cd_pes -- Alessandra 04/09/2019 - Ticket 100-155779
					left join DE_PARA DP with(nolock) on DP.Cd_Org = TT.Cd_Tp_Tx and DP.Cd_Cliente = PLLP.Cd_Pes_Grupo and DP.Cd_Tipo = 38-- -- Kaique 18/12/2025 - Ticket 100-538694
				WHERE 
					FATURA_PC=@FATURA_PC 
				group by 
					HOU.Num_Proc_HIO,Data_PC,fatDtVenc,obs_pc,obs_hio,right(pp.Num_CPF_CNPJ,14), Fatura_PC,pp.Apelido,pp.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,hawb_HIO ,ITM.CD_TP_TX,DP.Cd_Dst,NOME_TP_TX,VLR_PC, TP_PGTO, CNS.Nome_raz_Soc, LDE.Nome_Local,CCH.num_nf_hio
					,Repasse_TX ,p2.Nome_Raz_Soc  -- Alessandra 04/09/2019 - Ticket 100-155779
			END
			
		IF left(@fatura_pc,2)='EA' and (len(@Fatura_PC) = 15 or len(@fatura_pc)=14)
			BEGIN
				SELECT 
					Data_PC,fatDtVenc,obs_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ, Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,
					RUA,Numero,Cidade,UF,max(Numero_PO) Referencia_Cliente,DI_RE_PC,org.nome_local Origem, 
					dst.nome_local Destino,Mawb_mea House,ITM.CD_TP_TX,
					CASE
					WHEN cast(DP.Cd_Dst as varchar(100)) is null then TT.Nome_Tp_Tx
					else 
					cast(DP.Cd_Dst as varchar(100)) 
					end as NOME_TP_TX,
					VLR_PC, TP_PGTO, Obs_mea OBS_HOU, 
					CNS.Nome_Raz_Soc CNS, LDE.Nome_Local Local_Desemb,
					dbo.fBusca_Tarefa(MAS.Num_Proc_MEA,4) Dt_Desembaraco, 
--					Data_PC, fatDtVenc Vencimento,
--					max(CCM.NUM_NF_MEA) num_nf
					(select max(num_nf_mea) from cta_cte_mas_exp_aer where num_proc_mea = LEFT(FATURA_PC,14)) num_nf,

					(select (ref_acesso_nf_mea) from cta_cte_mas_exp_aer where num_proc_mea = LEFT(FATURA_PC,14)) [Site],					
					Repasse_TX 
					,p2.Nome_Raz_Soc as [Shipper] -- Alessandra 04/09/2019 - Ticket 100-155779
				FROM 
					FATURA_CHB FAT with(nolock)
					JOIN FATURA_CHB_ITEM ITM with(nolock)ON ITM.FATURA_CC=FAT.FATURA_PC
					JOIN PESSOA PP with(nolock)ON PP.CD_PES=CD_PES_PC
					JOIN Pessoa_LLP PLLP ON PP.Cd_Pes = PLLP.Cd_Pes -- - Kaique 18/12/2025 - Ticket 100-538694
					LEFT Join Endereco ED with(nolock)on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
					LEFT JOIN MASTER_EXP_aer MAS with(nolock)ON MAS.NUM_PROC_mea=LEFT(FATURA_PC,14)
					LEFT join cta_cte_mas_exp_aer CCM with(nolock)on CCM.num_proc_mEA = LEFT(FATURA_PC,14) and CCM.NUM_NF_MEA IS NOT NULL AND CCM.REF_ACESSO_NF_MEA <> 'P' AND CCM.REF_ACESSO_NF_MEA is not null and ccm.cd_tp_tx = ITM.cd_tp_tx
					join Tipo_Taxa TT with(nolock)on TT.cd_tp_Tx=itm.cd_tp_Tx 
					LEft Join PO_Master PO with(nolock)on lefT(fat.fatura_pc,14)=po.num_proC_master AND ID_DC = 1
					Left Join Localidade Org with(nolock)on Org.cd_local=cd_org_mea
					Left Join Localidade dst with(nolock) on dst.cd_local=cd_dst_mea
					left join Pessoa CNS with(nolock)on CNS.cd_pes = MAS.cd_export_mea
					Left Join Campo_Processo CP with(nolock)on CP.Num_Proc=left(@Fatura_PC,14) and Id_Campo=25
					Left Join Localidade LDE with(nolock)on LDE.cd_local=CP.Campo_Dados
					Left Join Fatura with(nolock)on fatcod=fatura_pc
					left join vwClienteALLJOBS vv with(nolock) on vv.num_proc=processo_pc -- Alessandra 04/09/2019 - Ticket 100-155779
					left join Pessoa p2 with(nolock) on  vv.cd_fornecedor = p2.cd_pes -- Alessandra 04/09/2019 - Ticket 100-155779
					left join DE_PARA DP with(nolock) on DP.Cd_Org = TT.Cd_Tp_Tx and DP.Cd_Cliente = PLLP.Cd_Pes_Grupo and DP.Cd_Tipo = 38-- -- Kaique 18/12/2025 - Ticket 100-538694
				WHERE 
					FATURA_PC=@FATURA_PC 
				group by 
					MAS.Num_Proc_MEA,Data_PC,fatDtVenc,obs_PC,obs_mea,right(pp.Num_CPF_CNPJ,14), Fatura_PC,pp.Apelido,pp.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,Mawb_mea ,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, CNS.Nome_Raz_Soc, LDE.Nome_Local,CCM.NUM_NF_MEA,
					DP.Cd_Dst,Repasse_TX,p2.Nome_Raz_Soc  -- Alessandra 04/09/2019 - Ticket 100-155779 
			END
			
		IF left(@fatura_pc,2)='EM' and (len(@Fatura_PC) = 15 or len(@fatura_pc)=14)
			BEGIN
				SELECT 
					Data_PC,fatDtVenc,obs_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ, Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,
					RUA,Numero,Cidade,UF,max(Numero_PO) Referencia_Cliente,DI_RE_PC,org.nome_local Origem, 
					dst.nome_local Destino,Mawb_mem House,ITM.CD_TP_TX,
					CASE
					WHEN cast(DP.Cd_Dst as varchar(100)) is null then TT.Nome_Tp_Tx
					else 
					cast(DP.Cd_Dst as varchar(100)) 
					end as NOME_TP_TX,
					VLR_PC, TP_PGTO, Obs_mem OBS_HOU, 
					CNS.Nome_Raz_Soc CNS, LDE.Nome_Local Local_Desemb,
					dbo.fBusca_Tarefa(MAS.Num_Proc_MEM,4) Dt_Desembaraco, 
--					Data_PC, fatDtVenc Vencimento, 
--					max(CCM.NUM_NF_MEM) num_nf
					(select max(num_nf_mem) from cta_cte_mas_exp_mar where num_proc_mem = LEFT(FATURA_PC,14)) num_nf,

					(select top 1 ref_acesso_nf_mem from cta_cte_mas_exp_mar where num_proc_mem = LEFT(FATURA_PC,14)) [Site],					
					Repasse_TX 
					,p2.Nome_Raz_Soc as [Shipper] -- Alessandra 04/09/2019 - Ticket 100-155779
				FROM
					FATURA_CHB FAT with(nolock)
					JOIN FATURA_CHB_ITEM ITM with(nolock)ON ITM.FATURA_CC=FAT.FATURA_PC
					JOIN PESSOA PP with(nolock)ON PP.CD_PES=CD_PES_PC
					JOIN Pessoa_LLP PLLP ON PP.Cd_Pes = PLLP.Cd_Pes -- - Kaique 18/12/2025 - Ticket 100-538694
					LEFT Join Endereco ED with(nolock)on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
					LEFT JOIN MASTER_EXP_mar MAS with(nolock)ON MAS.NUM_PROC_mem=LEFT(FATURA_PC,14)
					LEFT join cta_cte_mas_exp_mar CCM with(nolock)on CCM.num_proc_mEM = LEFT(FATURA_PC,14) and CCM.NUM_NF_MEM IS NOT NULL AND CCM.REF_ACESSO_NF_MEM <> 'P' AND CCM.REF_ACESSO_NF_MEM is not null and ccm.cd_tp_tx = ITM.cd_tp_tx
					join Tipo_Taxa TT with(nolock)on TT.cd_tp_Tx=itm.cd_tp_Tx
					LEft Join PO_Master PO with(nolock)on lefT(fat.fatura_pc,14)=po.num_proC_master AND ID_DC = 1
					Left Join Localidade Org with(nolock)on Org.cd_local=cd_org_mem
					Left Join Localidade dst with(nolock)on dst.cd_local=cd_dst_mem
					left join Pessoa CNS with(nolock)on CNS.cd_pes = MAS.cd_export_mem
					Left Join Campo_Processo CP with(nolock)on CP.Num_Proc=left(@Fatura_PC,14) and Id_Campo=25
					Left Join Localidade LDE with(nolock)on LDE.cd_local=CP.Campo_Dados
					Left Join Fatura with(nolock)on fatcod=fatura_pc
					left join vwClienteALLJOBS vv with(nolock) on vv.num_proc=processo_pc -- Alessandra 04/09/2019 - Ticket 100-155779
					left join Pessoa p2 with(nolock) on  vv.cd_fornecedor = p2.cd_pes -- Alessandra 04/09/2019 - Ticket 100-155779
					left join DE_PARA DP with(nolock) on DP.Cd_Org = TT.Cd_Tp_Tx and DP.Cd_Cliente = PLLP.Cd_Pes_Grupo and DP.Cd_Tipo = 38-- -- Kaique 18/12/2025 - Ticket 100-538694

				WHERE 
					FATURA_PC=@FATURA_PC 
				group by 
					MAS.Num_Proc_MEM,Data_PC,fatDtVenc,obs_PC,obs_mem,right(pp.Num_CPF_CNPJ,14), Fatura_PC,pp.Apelido,pp.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,Mawb_mem ,ITM.CD_TP_TX,DP.Cd_Dst,NOME_TP_TX,VLR_PC, TP_PGTO, CNS.Nome_Raz_Soc, LDE.Nome_Local,CCM.NUM_NF_MEM
					,Repasse_TX,p2.Nome_Raz_Soc  -- Alessandra 04/09/2019 - Ticket 100-155779 
			END
			
		IF left(@fatura_pc,2)='IM' and (len(@Fatura_PC) = 15 or len(@fatura_pc)=14)
			BEGIN
				SELECT 
					Data_PC,fatDtVenc,obs_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ, Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,
					RUA,Numero,Cidade,UF,max(Numero_PO) Referencia_Cliente,DI_RE_PC,org.nome_local Origem,
					dst.nome_local Destino,Mawb_mim House,ITM.CD_TP_TX,
					CASE
					WHEN cast(DP.Cd_Dst as varchar(100)) is null then TT.Nome_Tp_Tx
					else 
					cast(DP.Cd_Dst as varchar(100)) 
					end as NOME_TP_TX, -- Kaique 18/12/2025 - Ticket 100-538694
					VLR_PC, TP_PGTO, Obs_mim OBS_HOU, 
					CNS.Nome_Raz_Soc CNS, LDE.Nome_Local Local_Desemb,
					dbo.fBusca_Tarefa(MAS.Num_Proc_MIM,4) Dt_Desembaraco,
--					Data_PC, fatDtVenc Vencimento,
--					max(CCM.NUM_NF_MIM) num_nf
					(select max(num_nf_mim) from cta_cte_mas_imp_mar where num_proc_mim = LEFT(FATURA_PC,14)) num_nf,

					(select top 1 ref_acesso_nf_mim from cta_cte_mas_imp_mar where num_proc_mim = LEFT(FATURA_PC,14)) [Site],					
					Repasse_TX 
					,p2.Nome_Raz_Soc as [Shipper] -- Alessandra 04/09/2019 - Ticket 100-155779
				FROM
					FATURA_CHB FAT with(nolock)
					JOIN FATURA_CHB_ITEM ITM with(nolock)ON ITM.FATURA_CC=FAT.FATURA_PC
					JOIN PESSOA PP with(nolock)ON PP.CD_PES=CD_PES_PC
					JOIN Pessoa_LLP PLLP ON PP.Cd_Pes = PLLP.Cd_Pes -- - Kaique 18/12/2025 - Ticket 100-538694
					LEFT Join Endereco ED with(nolock)on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
					LEFT JOIN MASTER_imp_mar MAS with(nolock)ON MAS.NUM_PROC_mim=LEFT(FATURA_PC,14) 
					LEFT JOIN CTA_CTE_MAS_IMP_MAR CCM with(nolock)ON CCM.NUM_PROC_MIM = LEFT(FATURA_PC,14) AND CCM.NUM_NF_MIM IS NOT NULL AND CCM.REF_ACESSO_NF_MIM <> 'P' AND CCM.REF_ACESSO_NF_MIM is not null and ccm.cd_tp_tx = ITM.cd_tp_tx
					join Tipo_Taxa TT with(nolock)on TT.cd_tp_Tx=itm.cd_tp_Tx
					LEft Join PO_Master PO with(nolock)on lefT(fat.fatura_pc,14)=po.num_proC_master AND ID_DC = 1
					Left Join Localidade Org with(nolock)on Org.cd_local=cd_org_mim
					Left Join Localidade dst with(nolock)on dst.cd_local=cd_dst_mim
					left join Pessoa CNS with(nolock)on CNS.cd_pes = MAS.cd_consig_mim
					Left Join Campo_Processo CP with(nolock)on CP.Num_Proc=left(@Fatura_PC,14) and Id_Campo=25
					Left Join Localidade LDE with(nolock)on LDE.cd_local=CP.Campo_Dados
					Left Join Fatura with(nolock)on fatcod=fatura_pc
					left join vwClienteALLJOBS vv with(nolock) on vv.num_proc=processo_pc -- Alessandra 04/09/2019 - Ticket 100-155779
					left join Pessoa p2 with(nolock) on  vv.cd_fornecedor = p2.cd_pes -- Alessandra 04/09/2019 - Ticket 100-155779
					left join DE_PARA DP with(nolock) on DP.Cd_Org = TT.Cd_Tp_Tx and DP.Cd_Cliente = PLLP.Cd_Pes_Grupo and DP.Cd_Tipo = 38-- -- Kaique 18/12/2025 - Ticket 100-538694
				WHERE 
					FATURA_PC=@FATURA_PC 
				group by 
					MAS.Num_Proc_MIM,Data_PC,fatDtVenc,obs_PC,obs_mim,right(pp.Num_CPF_CNPJ,14), Fatura_PC,pp.Apelido,pp.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,Mawb_mim ,ITM.CD_TP_TX,DP.Cd_Dst,NOME_TP_TX,VLR_PC, TP_PGTO, CNS.Nome_Raz_Soc, LDE.Nome_Local,CCM.NUM_NF_MIM
					,Repasse_TX,p2.Nome_Raz_Soc  -- Alessandra 04/09/2019 - Ticket 100-155779 
			END
			
		IF left(@fatura_pc,2)='IA' and (len(@Fatura_PC) = 15 or len(@fatura_pc)=14)
			BEGIN
				SELECT 
					Data_PC,fatDtVenc,obs_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ, Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,
					RUA,Numero,Cidade,UF,max(Numero_PO) Referencia_Cliente,DI_RE_PC,org.nome_local Origem, 
					dst.nome_local Destino,Mawb_mia House,ITM.CD_TP_TX,
					CASE
					WHEN cast(DP.Cd_Dst as varchar(100)) is null then TT.Nome_Tp_Tx
					else 
					cast(DP.Cd_Dst as varchar(100)) 
					end as NOME_TP_TX, -- Kaique 18/12/2025 - Ticket 100-538694
					VLR_PC, TP_PGTO, Obs_mia OBS_HOU, 
					CNS.Nome_Raz_Soc CNS, LDE.Nome_Local Local_Desemb,
					dbo.fBusca_Tarefa(MAS.Num_Proc_MIA,4) Dt_Desembaraco, 
--					Data_PC, fatDtVenc Vencimento, 
--					max(CCM.NUM_NF_MIA) num_nf
					(select max(num_nf_mia) from cta_cte_mas_imp_aer where num_proc_mia = LEFT(FATURA_PC,14)) num_nf,

					(select top 1 ref_acesso_nf_mia from cta_cte_mas_imp_aer where num_proc_mia = LEFT(FATURA_PC,14)) [Site],					
					Repasse_TX 
					,p2.Nome_Raz_Soc as [Shipper] -- Alessandra 04/09/2019 - Ticket 100-155779
				FROM 
					FATURA_CHB FAT with(nolock)
					JOIN FATURA_CHB_ITEM ITM with(nolock)ON ITM.FATURA_CC=FAT.FATURA_PC
					JOIN PESSOA PP with(nolock)ON PP.CD_PES=CD_PES_PC
					JOIN Pessoa_LLP PLLP ON PP.Cd_Pes = PLLP.Cd_Pes -- - Kaique 18/12/2025 - Ticket 100-538694
					LEFT Join Endereco ED with(nolock)on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
					LEFT JOIN MASTER_imp_aer MAS with(nolock)ON MAS.NUM_PROC_mia=LEFT(FATURA_PC,14)
					LEFT join cta_cte_mas_imp_AER CCM with(nolock)on CCM.num_proc_mIA = LEFT(FATURA_PC,14) and CCM.NUM_NF_MIA IS NOT NULL AND CCM.REF_ACESSO_NF_MIA <> 'P' AND CCM.REF_ACESSO_NF_MIA is not null and ccm.cd_tp_tx = ITM.cd_tp_tx
					join Tipo_Taxa TT with(nolock)on TT.cd_tp_Tx=itm.cd_tp_Tx
					LEft Join PO_Master PO with(nolock)on lefT(fat.fatura_pc,14)=po.num_proC_master AND ID_DC = 1
					Left Join Localidade Org with(nolock)on Org.cd_local=cd_org_mia
					Left Join Localidade dst with(nolock)on dst.cd_local=cd_dst_mia
					left join Pessoa CNS with(nolock)on CNS.cd_pes = MAS.cd_export_mia
					Left Join Campo_Processo CP with(nolock)on CP.Num_Proc=left(@Fatura_PC,14) and Id_Campo=25
					Left Join Localidade LDE with(nolock)on LDE.cd_local=CP.Campo_Dados
					Left Join Fatura with(nolock)on fatcod=fatura_pc
					left join vwClienteALLJOBS vv with(nolock) on vv.num_proc=processo_pc -- Alessandra 04/09/2019 - Ticket 100-155779
					left join Pessoa p2 with(nolock) on  vv.cd_fornecedor = p2.cd_pes -- Alessandra 04/09/2019 - Ticket 100-155779
					left join DE_PARA DP with(nolock) on DP.Cd_Org = TT.Cd_Tp_Tx and DP.Cd_Cliente = PLLP.Cd_Pes_Grupo and DP.Cd_Tipo = 38-- -- Kaique 18/12/2025 - Ticket 100-538694
				WHERE 
					FATURA_PC=@FATURA_PC 
				group by 
					MAS.Num_Proc_MIA,Data_PC,fatDtVenc,obs_PC,obs_mia,right(pp.Num_CPF_CNPJ,14), Fatura_PC,pp.Apelido,pp.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,Mawb_mia ,ITM.CD_TP_TX,DP.Cd_Dst,NOME_TP_TX,VLR_PC, TP_PGTO, CNS.Nome_Raz_Soc, LDE.Nome_Local,CCM.NUM_NF_MIA
					,Repasse_TX,p2.Nome_Raz_Soc  -- Alessandra 04/09/2019 - Ticket 100-155779 
			END
	END

GO
