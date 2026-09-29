SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--select * from FATURA_CHB  where FATURA_PC like '%ocv%'
--
--IMOWE201205003BRA
--IMOVC201207001BRA

/*
	Criado para a OWENS, pra ter sequencia qdo aparece as taxas
	2. Prestação de Contas
	No documento deverão constar:
	2.1 Despesas na Seguinte Ordem /Sequencia:
	A. PIS
	B. COFINS
	C. ICMS
	D. IPI
	E. Imposto de Importação
	F. Serviços de Despachante 
	G. Todas as Despesas que houverem ( BL, THC, Transporte, Armazenagem, ......etc)
*/
--22-12-2016 - BO
--17-04-2018 - incluido o num-proc_hbo
CREATE Procedure [dbo].[spPrestCC_REL_OVC_17-09-2018]--[dbo].[spPrestCC_REL_OVC] 'IAOCV201208001BRA','S'
		@Fatura_PC varchar(17),
		@Tipo	Varchar(1)

as

	Declare @Table Table
		(
			Data_PC	Datetime,
			fatDtVenc Datetime,
			OBS		Varchar(500),
			Num_CPF_CNPJ varchar(20),
			Fatura_PC	Varchar(17),
			Apelido		Varchar(50),
			Nome_Raz_Soc	varchar(50),
			RUA				Varchar(150),
			Numero			Varchar(50),
			Cidade			Varchar(50),
			UF				Char(2),
			Referencia_Cliente	Varchar(150),
			DI_RE_PC			Varchar(50),
			Origem				Varchar(50),
			Destino				Varchar(50),
			House				Varchar(50),
			CD_TP_TX			varchar(3),
			NOME_TP_TX			varchar(500),
			VLR_PC				Decimal(10,2),
			TP_PGTO				Char(1),
			OBS_HOU				Varchar(500),
			CNS					Varchar(100),
			Local_Desemb		Varchar(100),
			Dt_Desembaraco		Datetime,
			Vencimento			Datetime,
			num_nf				Varchar(100),
			Order_By			int,
			Num_Proc_HBO		Varchar(16)
			)
	--select * from @table
	Declare @Cd_Pes Varchar(10)
	
--	Set @CD_PES=(select cd_pes_Grupo from grupo where grupo=substring('IMOCV201205001BRA',3,3))

	Set @CD_PES='P000007153'

IF @TIPO='S'
	BEGIN
	
		if left(@fatura_pc,2)='BO' and (len(@Fatura_PC) = 17 or len(@fatura_pc)=16)
			BEGIN
				insert @table
					SELECT 
						Distinct
						Data_PC,
						fatDtVenc,
						Obs_PC OBS,
						right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ,
						Fatura_PC,
						PP.Apelido,
						PP.Nome_Raz_Soc,
						RUA,
						Numero,
						Cidade,
						UF,
						max(Numero_PO_HBO) Referencia_Cliente,
						DI_RE_PC,
						'' Origem,
						'' Destino,
						'' House,
						ITM.CD_TP_TX,
						NOME_TP_TX,
						VLR_PC,
						TP_PGTO,
						'' OBS_HOU,
						CNS.Nome_Raz_Soc CNS,
						LDE.Nome_Local Local_Desemb,
						dbo.fBusca_Tarefa(HOU.Num_Proc_HBO,4) Dt_Desembaraco,
						fatDtVenc Vencimento,
						Max(CCH.Num_NF_HBO) num_nf,
						isnull(Ordem,99) Order_By,
						[dbo].[fBusca_Docs_PO_Modal](LEFT(FATURA_PC,16),19) Num_Proc_HBO
						
		
					FROM 
						FATURA_CHB FAT
						JOIN FATURA_CHB_ITEM ITM ON ITM.FATURA_CC=FAT.FATURA_PC
						JOIN PESSOA PP ON PP.CD_PES=CD_PES_PC 
						LEFT Join Endereco ED on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
						LEFT JOIN House_BDP_OUT HOU ON HOU.Num_Proc_HBO=LEFT(FATURA_PC,16)
						LEFT JOIN Cta_Cte_HOU_BDP_OUT CCH on CCH.num_proc_hbo = LEFT(FATURA_PC,16) and CCH.num_nf_hbo is not null AND CCH.Ref_Acesso_NF_HBO <> 'P' AND CCH.Ref_Acesso_NF_HBO is not null
						join Tipo_Taxa TT on TT.cd_tp_Tx=itm.cd_tp_Tx
						LEft Join PO_HBO PO on lefT(fat.fatura_pc,16)=po.Num_Proc_HBO AND ID_DC = 1
						--Join Localidade Org on Org.cd_local=cd_org_HEO
						--Join Localidade dst on dst.cd_local=cd_dst_HEO
						left join Pessoa CNS on CNS.cd_pes = HOU.cd_cliente_hbo
						Left Join Campo_Processo CP on CP.Num_Proc=left(@Fatura_PC,16) and Id_Campo=25
						Left Join Localidade LDE on LDE.cd_local=CP.Campo_Dados
						Left Join Fatura on fatcod=fatura_pc
						Left Join Tipo_Taxa_PC_CHB TCHB on TCHB.cd_tp_tx=TT.cd_tp_tx and cd_pes_grupo=@cd_pes
					WHERE 
						FATURA_PC=@FATURA_PC and imprime='S'
					group by 
						HOU.Num_Proc_HBO, Data_pc,fatdtvenc,Obs_Pc,
						--Obs_HBo,
						right(PP.Num_CPF_CNPJ,14),Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,
						--org.nome_local , dst.nome_local ,hawb_HEO ,
						ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, CNS.Nome_Raz_Soc, LDE.Nome_Local,Ordem
					Order by order_by
			END

	    if left(@fatura_pc,2)='EO' and (len(@Fatura_PC) = 17 or len(@fatura_pc)=16)
		BEGIN
			insert @table
			SELECT 
				Distinct
				Data_PC,
				fatDtVenc,
				Obs_PC OBS,
				right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ,
				Fatura_PC,
				PP.Apelido,
				PP.Nome_Raz_Soc,
				RUA,
				Numero,
				Cidade,
				UF,
				max(Numero_PO_HEO) Referencia_Cliente,
				DI_RE_PC,
				org.nome_local Origem,
				dst.nome_local Destino,
				hawb_HEO House,
				ITM.CD_TP_TX,
				NOME_TP_TX,
				VLR_PC,
				TP_PGTO,
				Obs_heo OBS_HOU,
				CNS.Nome_Raz_Soc CNS,
				LDE.Nome_Local Local_Desemb,
				dbo.fBusca_Tarefa(HOU.Num_Proc_HEO,4) Dt_Desembaraco,
				fatDtVenc Vencimento,
				Max(CCH.num_nf_heo) num_nf,
				isnull(Ordem,99) Order_By,[dbo].[fBusca_Docs_PO_Modal](LEFT(FATURA_PC,16),19) Num_Proc_HBO
			FROM 
				FATURA_CHB FAT
				JOIN FATURA_CHB_ITEM ITM ON ITM.FATURA_CC=FAT.FATURA_PC
				JOIN PESSOA PP ON PP.CD_PES=CD_PES_PC 
				LEFT Join Endereco ED on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
				LEFT JOIN HOUSE_EXP_OUT HOU ON HOU.NUM_PROC_HEO=LEFT(FATURA_PC,16)
				LEFT JOIN cta_cte_hou_exp_out CCH on CCH.num_proc_heo = LEFT(FATURA_PC,16) and CCH.num_nf_heo is not null AND CCH.REF_ACESSO_NF_Heo <> 'P' AND CCH.REF_ACESSO_NF_Heo is not null
				join Tipo_Taxa TT on TT.cd_tp_Tx=itm.cd_tp_Tx
				LEft Join PO_HEO PO on lefT(fat.fatura_pc,16)=po.num_proC_HEO AND ID_DC = 1
				Join Localidade Org on Org.cd_local=cd_org_HEO
				Join Localidade dst on dst.cd_local=cd_dst_HEO
				left join Pessoa CNS on CNS.cd_pes = HOU.cd_export_HEO
				Left Join Campo_Processo CP on CP.Num_Proc=left(@Fatura_PC,16) and Id_Campo=25
				Left Join Localidade LDE on LDE.cd_local=CP.Campo_Dados
				Left Join Fatura on fatcod=fatura_pc
				Left Join Tipo_Taxa_PC_CHB TCHB on TCHB.cd_tp_tx=TT.cd_tp_tx and cd_pes_grupo=@cd_pes
			WHERE 
				FATURA_PC=@FATURA_PC and imprime='S'
			group by 
				HOU.Num_Proc_HEO, Data_pc,fatdtvenc,Obs_Pc,Obs_Heo,right(PP.Num_CPF_CNPJ,14),Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,hawb_HEO ,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, CNS.Nome_Raz_Soc, LDE.Nome_Local,Ordem
			Order by order_by
		END

	    if left(@fatura_pc,2)='IO' and (len(@Fatura_PC) = 17 or len(@fatura_pc)=16)
		BEGIN
		insert @table
			SELECT 
				Distinct
				Data_PC,fatdtvenc,Obs_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ ,Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,RUA,Numero,Cidade,UF,max(Numero_PO_HIO) Referencia_Cliente,DI_RE_PC,org.nome_local Origem, dst.nome_local Destino,hawb_HIO House,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO,Obs_hio OBS_HOU, CNS.Nome_Raz_Soc CNS, LDE.Nome_Local Local_Desemb,
				dbo.fBusca_Tarefa(HOU.Num_Proc_HIO,4) Dt_Desembaraco,fatDtVenc Vencimento, MAx(cch.num_nf_hio) num_nf,isnull(Ordem,99) Order_By,[dbo].[fBusca_Docs_PO_Modal](LEFT(FATURA_PC,16),19) Num_Proc_HBO
			FROM 
				FATURA_CHB FAT
				JOIN FATURA_CHB_ITEM ITM ON ITM.FATURA_CC=FAT.FATURA_PC
				JOIN PESSOA PP ON PP.CD_PES=CD_PES_PC 
				LEFT Join Endereco ED on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
				LEFT JOIN HOUSE_IMP_OUT HOU ON HOU.NUM_PROC_HIO=LEFT(FATURA_PC,16)
				LEFT JOIN cta_cte_hou_imp_out CCH on CCH.num_proc_hio = LEFT(FATURA_PC,16) and CCH.num_nf_hio is not null AND CCH.REF_ACESSO_NF_HIo <> 'P' AND CCH.REF_ACESSO_NF_Hio is not null
				join Tipo_Taxa TT on TT.cd_tp_Tx=itm.cd_tp_Tx
				LEft Join PO_HIO PO on lefT(fat.fatura_pc,16)=po.num_proC_HIO AND ID_DC = 1
				Join Localidade Org on Org.cd_local=cd_org_HIO
				Join Localidade dst on dst.cd_local=cd_dst_HIO
				left join Pessoa CNS on CNS.cd_pes = HOU.cd_consig_HIO
				Left Join Campo_Processo CP on CP.Num_Proc=left(@Fatura_PC,16) and Id_Campo=25
				Left Join Localidade LDE on LDE.cd_local=CP.Campo_Dados
				Left Join Fatura on fatcod=fatura_pc
				Left Join Tipo_Taxa_PC_CHB TCHB on TCHB.cd_tp_tx=TT.cd_tp_tx and cd_pes_grupo=@cd_pes
			WHERE 
				FATURA_PC=@FATURA_PC and imprime='S'
			group by 
				HOU.Num_Proc_HIO,Data_PC,fatdtvenc,Obs_PC,obs_hio,right(PP.Num_CPF_CNPJ,14),Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,hawb_HIO ,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, CNS.Nome_Raz_Soc, LDE.Nome_Local,Ordem
			Order by order_by
		END

	    if left(@fatura_pc,2)='IM' and (len(@Fatura_PC) = 17 or len(@Fatura_PC) = 16)
		BEGIN
			insert @table
			SELECT 
				Distinct
				Data_PC,fatdtvenc,OBS_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ ,Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,RUA,Numero,Cidade,UF,max(Numero_PO_HIM) Referencia_Cliente,DI_RE_PC,org.nome_local Origem, dst.nome_local Destino,hawb_him House,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, Obs_him OBS_HOU, CNS.Nome_Raz_Soc CNS, LDE.Nome_Local Local_Desemb,
				dbo.fBusca_Tarefa(HOU.Num_Proc_HIM,4) Dt_Desembaraco,fatDtVenc Vencimento,max(CCH.num_nf_him) num_nf,isnull(Ordem,99) Order_By,[dbo].[fBusca_Docs_PO_Modal](LEFT(FATURA_PC,16),19) Num_Proc_HBO
			FROM 
				FATURA_CHB FAT
				JOIN FATURA_CHB_ITEM ITM ON ITM.FATURA_CC=FAT.FATURA_PC
				JOIN PESSOA PP ON PP.CD_PES=CD_PES_PC
				LEFT Join Endereco ED on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
				LEFT JOIN HOUSE_IMP_MAR HOU ON HOU.NUM_PROC_HIM=LEFT(FATURA_PC,16)
				LEFT JOIN cta_cte_hou_imp_mar CCH on CCH.num_proc_him = LEFT(FATURA_PC,16) and CCH.num_nf_him is not null AND CCH.REF_ACESSO_NF_HIM <> 'P' AND CCH.REF_ACESSO_NF_Him is not null
				join Tipo_Taxa TT on TT.cd_tp_Tx=itm.cd_tp_Tx
				LEft Join PO_HIM PO on lefT(fat.fatura_pc,16)=po.num_proC_him AND ID_DC = 1
				Join Localidade Org on Org.cd_local=cd_org_him
				Join Localidade dst on dst.cd_local=cd_dst_him
				left join Pessoa CNS on CNS.cd_pes = HOU.cd_consig_HIM
				Left Join Campo_Processo CP on CP.Num_Proc=left(@Fatura_PC,16) and Id_Campo=25
				Left Join Localidade LDE on LDE.cd_local=CP.Campo_Dados
				Left Join Fatura on fatcod=fatura_pc
				Left Join Tipo_Taxa_PC_CHB TCHB on TCHB.cd_tp_tx=TT.cd_tp_tx and cd_pes_grupo=@cd_pes
			WHERE 
				FATURA_PC=@FATURA_PC and imprime='S'
			group by 
				HOU.Num_Proc_HIM,Data_PC,fatdtvenc,Obs_PC,obs_him,right(pp.Num_CPF_CNPJ,14),Fatura_PC,pp.Apelido,pp.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,hawb_him ,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, CNS.Nome_Raz_Soc, LDE.Nome_Local,Ordem
			Order by order_by
			END
		
		IF left(@fatura_pc,2)='IA' and (len(@Fatura_PC) = 17 or len(@fatura_pc)=16)
			BEGIN
				insert @table
				SELECT 
					Data_PC,fatdtvenc,Obs_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ, Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,RUA,Numero,Cidade,UF, max(Numero_PO_hia) Referencia_Cliente,DI_RE_PC,org.nome_local Origem, dst.nome_local Destino,hawb_hia House,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, Obs_hia OBS_HOU, CNS.Nome_Raz_Soc CNS, LDE.Nome_Local Local_Desemb,
					dbo.fBusca_Tarefa(HOU.Num_Proc_HIA,4) Dt_Desembaraco,fatDtVenc Vencimento, Max(cch.num_nf_hia) num_nf,isnull(Ordem,99) Order_By,[dbo].[fBusca_Docs_PO_Modal](LEFT(FATURA_PC,16),19) Num_Proc_HBO
				FROM 
					FATURA_CHB FAT
					JOIN FATURA_CHB_ITEM ITM ON ITM.FATURA_CC=FAT.FATURA_PC
					JOIN PESSOA PP ON PP.CD_PES=CD_PES_PC
					LEFT Join Endereco ED on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
					LEFT JOIN HOUSE_IMP_aer HOU ON HOU.NUM_PROC_hia=LEFT(FATURA_PC,16)
					LEFT JOIN cta_cte_hou_imp_aer CCH on CCH.num_proc_hia = LEFT(FATURA_PC,16) and CCH.num_nf_hia is not null AND CCH.REF_ACESSO_NF_HIa <> 'P' AND CCH.REF_ACESSO_NF_Hia is not null
					join Tipo_Taxa TT on TT.cd_tp_Tx=itm.cd_tp_Tx
					LEft Join PO_hia PO on lefT(fat.fatura_pc,16)=po.num_proC_hia  AND ID_DC = 1
					Join Localidade Org on Org.cd_local=cd_org_hia
					Join Localidade dst on dst.cd_local=cd_dst_hia
					left join Pessoa CNS on CNS.cd_pes = HOU.cd_consig_HIA
					Left Join Campo_Processo CP on CP.Num_Proc=left(@Fatura_PC,16) and Id_Campo=25
					Left Join Localidade LDE on LDE.cd_local=CP.Campo_Dados
					Left Join Fatura on fatcod=fatura_pc
					Left Join Tipo_Taxa_PC_CHB TCHB on TCHB.cd_tp_tx=TT.cd_tp_tx and cd_pes_grupo=@cd_pes
				WHERE 
					FATURA_PC=@FATURA_PC and imprime='S'
				group by 
					HOU.Num_Proc_HIA,Data_PC,fatdtvenc,obs_PC,obs_hia,right(pp.Num_CPF_CNPJ,14), Fatura_PC,pp.Apelido,pp.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,hawb_hia ,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, CNS.Nome_Raz_Soc, LDE.Nome_Local,Ordem
				Order by order_by
			END		
		IF left(@fatura_pc,2)='EM' and (len(@Fatura_PC) = 17 or len(@fatura_pc)=16)
			BEGIN
				insert @table
				SELECT 
					Data_PC,fatdtvenc,OBS_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ ,Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,RUA,Numero,Cidade,UF,max(Numero_PO_HEM) Referencia_Cliente,DI_RE_PC,org.nome_local Origem, dst.nome_local Destino,hawb_HEM House,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, Obs_hem OBS_HOU, CNS.Nome_Raz_Soc CNS, LDE.Nome_Local Local_Desemb,
					dbo.fBusca_Tarefa(HOU.Num_Proc_HEM,4) Dt_Desembaraco,fatDtVenc Vencimento, max(cch.num_nf_hem) num_nf,isnull(Ordem,99) Order_By,[dbo].[fBusca_Docs_PO_Modal](LEFT(FATURA_PC,16),19) Num_Proc_HBO
				FROM 
					FATURA_CHB FAT
					JOIN FATURA_CHB_ITEM ITM ON ITM.FATURA_CC=FAT.FATURA_PC
					JOIN PESSOA PP ON PP.CD_PES=CD_PES_PC
					LEFT Join Endereco ED on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
					LEFT JOIN HOUSE_EXP_MAR HOU ON HOU.NUM_PROC_HEM=LEFT(FATURA_PC,16)
					LEFT JOIN cta_cte_hou_exp_mar CCH on CCH.num_proc_hem = LEFT(FATURA_PC,16) 
					and CCH.num_nf_hem is not null AND CCH.REF_ACESSO_NF_HeM <> 'P'
					join Tipo_Taxa TT on TT.cd_tp_Tx=itm.cd_tp_Tx
					LEft Join PO_HEM PO on lefT(fat.fatura_pc,16)=po.num_proC_HEM AND ID_DC = 1
					Join Localidade Org on Org.cd_local=cd_org_HEM
					Join Localidade dst on dst.cd_local=cd_dst_HEM
					left join Pessoa CNS on CNS.cd_pes = HOU.cd_export_HEM
					Left Join Campo_Processo CP on CP.Num_Proc=left(@Fatura_PC,16) and Id_Campo=25
					Left Join Localidade LDE on LDE.cd_local=CP.Campo_Dados
					Left Join Fatura on fatcod=fatura_pc
					Left Join Tipo_Taxa_PC_CHB TCHB on TCHB.cd_tp_tx=TT.cd_tp_tx and cd_pes_grupo=@cd_pes
				WHERE 
					FATURA_PC=@FATURA_PC and IMPrime='S'
				group by 
					HOU.Num_Proc_HEM,Data_PC,fatdtvenc,OBS_PC,obs_hem,right(pp.Num_CPF_CNPJ,14),Fatura_PC,pp.Apelido,pp.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,hawb_HEM ,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, CNS.Nome_Raz_Soc, LDE.Nome_Local,Ordem
				Order by order_by
			END
		
		IF left(@fatura_pc,2)='EA' and (len(@Fatura_PC) = 17 or len(@fatura_pc)=16)
			BEGIN
			insert @table
				SELECT 
					Data_PC,fatdtvenc,obs_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ, Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,RUA,Numero,Cidade,UF,max(Numero_PO_HEA) Referencia_Cliente,DI_RE_PC,org.nome_local Origem, dst.nome_local Destino,hawb_HEA House,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, Obs_hea OBS_HOU, CNS.Nome_Raz_Soc CNS, LDE.Nome_Local Local_Desemb,
					dbo.fBusca_Tarefa(HOU.Num_Proc_HEA,4) Dt_Desembaraco,fatDtVenc Vencimento, Max(CCH.num_nf_hea) num_nf,isnull(Ordem,99) Order_By,[dbo].[fBusca_Docs_PO_Modal](LEFT(FATURA_PC,16),19) Num_Proc_HBO
				FROM 
					FATURA_CHB FAT
					JOIN FATURA_CHB_ITEM ITM ON ITM.FATURA_CC=FAT.FATURA_PC
					JOIN PESSOA PP ON PP.CD_PES=CD_PES_PC
					LEFT Join Endereco ED on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
					LEFT JOIN HOUSE_EXP_aer HOU ON HOU.NUM_PROC_HEA=LEFT(FATURA_PC,16)
					LEFT JOIN cta_cte_hou_exp_aer CCH on CCH.num_proc_hea = LEFT(FATURA_PC,16) and CCH.num_nf_hea is not null AND CCH.REF_ACESSO_NF_Hea <> 'P' AND CCH.REF_ACESSO_NF_Hea is not null
					join Tipo_Taxa TT on TT.cd_tp_Tx=itm.cd_tp_Tx
					LEft Join PO_HEA PO on lefT(fat.fatura_pc,16)=po.num_proC_HEA AND ID_DC = 1
					Join Localidade Org on Org.cd_local=cd_org_HEA
					Join  Localidade dst on dst.cd_local=cd_dst_HEA
					left join Pessoa CNS on CNS.cd_pes = HOU.cd_export_HEA
					Left Join Campo_Processo CP on CP.Num_Proc=left(@Fatura_PC,16) and Id_Campo=25
					Left Join Localidade LDE on LDE.cd_local=CP.Campo_Dados
					Left Join Fatura on fatcod=fatura_pc
					Left Join Tipo_Taxa_PC_CHB TCHB on TCHB.cd_tp_tx=TT.cd_tp_tx and cd_pes_grupo=@cd_pes
				where 
					FATURA_PC=@FATURA_PC and IMPrime='S'
				group by 
					HOU.Num_Proc_HEA,Data_PC,fatdtvenc,obs_PC,obs_hea,right(pp.Num_CPF_CNPJ,14), Fatura_PC,pp.Apelido,pp.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,hawb_HEA ,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, CNS.Nome_Raz_Soc, LDE.Nome_Local,Ordem
				Order by order_by
			END

		IF left(@fatura_pc,2)='EA' and (len(@Fatura_PC) = 15 or len(@fatura_pc)=14)
		
			BEGIN
			insert @table
				SELECT 
					Data_PC,fatdtvenc,obs_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ, Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,RUA,Numero,Cidade,UF,max(Numero_PO) Referencia_Cliente,DI_RE_PC,org.nome_local Origem, dst.nome_local Destino,Mawb_MEA HOUSE,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, Obs_MEA OBS_MAS, CNS.Nome_Raz_Soc CNS, LDE.Nome_Local Local_Desemb,
					dbo.fBusca_Tarefa(MAS.Num_Proc_MEA,4) Dt_Desembaraco,fatDtVenc Vencimento, 
					--MAx(CCM.NUM_NF_MeA)) num_nf
					(select max(num_nf_mea) from cta_cte_mas_exp_aer where num_proc_mea = LEFT(FATURA_PC,14)) num_nf,isnull(Ordem,99) Order_By,[dbo].[fBusca_Docs_PO_Modal](LEFT(FATURA_PC,16),19) Num_Proc_HBO
				FROM 
					FATURA_CHB FAT
					JOIN FATURA_CHB_ITEM ITM ON ITM.FATURA_CC=FAT.FATURA_PC
					JOIN PESSOA PP ON PP.CD_PES=CD_PES_PC
					LEFT Join Endereco ED on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
					LEFT JOIN MASTER_EXP_aer MAS ON MAS.NUM_PROC_MEA=LEFT(FATURA_PC,14)
					--LEFT join cta_cte_mas_exp_AER CCM on CCM.num_proc_meA = LEFT(FATURA_PC,14) and CCM.NUM_NF_MeA IS NOT NULL AND CCM.REF_ACESSO_NF_MeA <> 'P' AND CCM.REF_ACESSO_NF_MEA is not null
					join Tipo_Taxa TT on TT.cd_tp_Tx=itm.cd_tp_Tx
					LEft Join PO_Master PO on lefT(fat.fatura_pc,14)=po.num_proC_Master AND ID_DC = 1
					Join Localidade Org on Org.cd_local=cd_org_MEA
					Join  Localidade dst on dst.cd_local=cd_dst_MEA
					left join Pessoa CNS on CNS.cd_pes = MAS.cd_export_MEA
					Left Join Campo_Processo CP on CP.Num_Proc=left(@Fatura_PC,14) and Id_Campo=25
					Left Join Localidade LDE on LDE.cd_local=CP.Campo_Dados
					Left Join Fatura on fatcod=fatura_pc
					Left Join Tipo_Taxa_PC_CHB TCHB on TCHB.cd_tp_tx=TT.cd_tp_tx and cd_pes_grupo=@cd_pes
				where 
					FATURA_PC=@FATURA_PC and IMPrime='S'
				group by 
					MAS.Num_Proc_MEA,Data_PC,fatdtvenc,obs_PC,obs_MEA,right(pp.Num_CPF_CNPJ,14), Fatura_PC,pp.Apelido,pp.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,Mawb_MEA ,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, CNS.Nome_Raz_Soc, LDE.Nome_Local,Ordem
				Order by order_by
			END
		IF left(@fatura_pc,2)='EM' and (len(@Fatura_PC) = 15 or len(@fatura_pc)=14)
		
			BEGIN
			insert @table
				SELECT 
					Data_PC,fatdtvenc,obs_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ, Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,RUA,Numero,Cidade,UF,max(Numero_PO) Referencia_Cliente,DI_RE_PC,org.nome_local Origem, dst.nome_local Destino,Mawb_mem HOUSE,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, Obs_mem OBS_MAS, CNS.Nome_Raz_Soc CNS, LDE.Nome_Local Local_Desemb,
					dbo.fBusca_Tarefa(MAS.Num_Proc_MEM,4) Dt_Desembaraco,fatDtVenc Vencimento, 
					--Max(CCM.NUM_NF_Mem) num_nf
					(select max(num_nf_mem) from cta_cte_mas_exp_mar where num_proc_mem = LEFT(FATURA_PC,14)) num_nf,isnull(Ordem,99) Order_By,[dbo].[fBusca_Docs_PO_Modal](LEFT(FATURA_PC,16),19) Num_Proc_HBO
				FROM
					FATURA_CHB FAT
					JOIN FATURA_CHB_ITEM ITM ON ITM.FATURA_CC=FAT.FATURA_PC
					JOIN PESSOA PP ON PP.CD_PES=CD_PES_PC
					LEFT Join Endereco ED on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
					LEFT JOIN MASTER_EXP_mar MAS ON MAS.NUM_PROC_mem=LEFT(FATURA_PC,14)
					--LEFT join cta_cte_mas_exp_mar CCM on CCM.num_proc_mem = LEFT(FATURA_PC,14) and CCM.NUM_NF_MeM IS NOT NULL AND CCM.REF_ACESSO_NF_MeM <> 'P' AND CCM.REF_ACESSO_NF_MEM is not null
					join Tipo_Taxa TT on TT.cd_tp_Tx=itm.cd_tp_Tx
					LEft Join PO_Master PO on lefT(fat.fatura_pc,14)=po.num_proC_Master AND ID_DC = 1
					Join Localidade Org on Org.cd_local=cd_org_mem
					Join  Localidade dst on dst.cd_local=cd_dst_mem
					left join Pessoa CNS on CNS.cd_pes = MAS.cd_export_mem
					Left Join Campo_Processo CP on CP.Num_Proc=left(@Fatura_PC,14) and Id_Campo=25
					Left Join Localidade LDE on LDE.cd_local=CP.Campo_Dados
					Left Join Fatura on fatcod=fatura_pc
					Left Join Tipo_Taxa_PC_CHB TCHB on TCHB.cd_tp_tx=TT.cd_tp_tx and cd_pes_grupo=@cd_pes
				where 
					FATURA_PC=@FATURA_PC and IMPrime='S'
				group by 
					MAS.Num_Proc_MEM,Data_PC,fatdtvenc,obs_PC,obs_mem,right(pp.Num_CPF_CNPJ,14), Fatura_PC,pp.Apelido,pp.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,Mawb_mem ,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, CNS.Nome_Raz_Soc, LDE.Nome_Local,Ordem
				Order by order_by
			END
		IF left(@fatura_pc,2)='IM' and (len(@Fatura_PC) = 15 OR len(@Fatura_PC) = 14)
			BEGIN
			insert @table
				SELECT 
					Data_PC,fatdtvenc,obs_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ, Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,RUA,Numero,Cidade,UF,max(Numero_PO) Referencia_Cliente,DI_RE_PC,org.nome_local Origem, dst.nome_local Destino,Mawb_mim HOUSE,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, Obs_mim OBS_MAS, CNS.Nome_Raz_Soc CNS, LDE.Nome_Local Local_Desemb, 
					dbo.fBusca_Tarefa(MAS.Num_Proc_MIM,4) Dt_Desembaraco,fatDtVenc Vencimento,
					--max(CCM.NUM_NF_MIM) num_nf
					(select max(num_nf_mim) from cta_cte_mas_imp_mar where num_proc_mim = LEFT(FATURA_PC,14)) num_nf,isnull(Ordem,99) Order_By,[dbo].[fBusca_Docs_PO_Modal](LEFT(FATURA_PC,16),19) Num_Proc_HBO
				FROM 
					FATURA_CHB FAT
					JOIN FATURA_CHB_ITEM ITM ON ITM.FATURA_CC=FAT.FATURA_PC
					JOIN PESSOA PP ON PP.CD_PES=CD_PES_PC
					LEFT Join Endereco ED on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
					LEFT JOIN MASTER_imp_mar MAS ON MAS.NUM_PROC_mim=LEFT(FATURA_PC,14)
					--LEFT join cta_cte_mas_imp_mar CCM on CCM.num_proc_mim = LEFT(FATURA_PC,14) and CCM.NUM_NF_MIM IS NOT NULL AND CCM.REF_ACESSO_NF_MIM <> 'P' AND CCM.REF_ACESSO_NF_MIM is not null
					join Tipo_Taxa TT on TT.cd_tp_Tx=itm.cd_tp_Tx
					LEft Join PO_Master PO on lefT(fat.fatura_pc,14)=po.num_proC_Master AND ID_DC = 1
					Join Localidade Org on Org.cd_local=cd_org_mim
					Join  Localidade dst on dst.cd_local=cd_dst_mim
					left join Pessoa CNS on CNS.cd_pes = MAS.cd_consig_mim
					Left Join Campo_Processo CP on CP.Num_Proc=left(@Fatura_PC,14) and Id_Campo=25
					Left Join Localidade LDE on LDE.cd_local=CP.Campo_Dados
					Left Join Fatura on fatcod=fatura_pc
					Left Join Tipo_Taxa_PC_CHB TCHB on TCHB.cd_tp_tx=TT.cd_tp_tx and cd_pes_grupo=@cd_pes
				where 
					FATURA_PC=@FATURA_PC and IMPrime='S'
				group by 
					MAS.Num_Proc_MIM,Data_PC,fatdtvenc,obs_PC,obs_mim,right(pp.Num_CPF_CNPJ,14), Fatura_PC,pp.Apelido,pp.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,Mawb_mim ,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, CNS.Nome_Raz_Soc, LDE.Nome_Local,Ordem--,NUM_NF_MIM
				Order by order_by
			END
		IF left(@fatura_pc,2)='IA' and (len(@Fatura_PC) = 15 or len(@fatura_pc)=14)

			BEGIN
			insert @table
				SELECT 
					Data_PC,fatdtvenc,obs_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ, Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,RUA,Numero,Cidade,UF,max(Numero_PO) Referencia_Cliente,DI_RE_PC,org.nome_local Origem, dst.nome_local Destino,Mawb_mia HOUSE,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, Obs_mia OBS_MAS, CNS.Nome_Raz_Soc CNS, LDE.Nome_Local Local_Desemb,
					dbo.fBusca_Tarefa(MAS.Num_Proc_MIA,4) Dt_Desembaraco ,fatDtVenc Vencimento,
--					max(CCM.NUM_NF_MIA) num_nf
					(select max(num_nf_mia) from cta_cte_mas_imp_aer where num_proc_mia = LEFT(FATURA_PC,14)) num_nf,isnull(Ordem,99) Order_By,[dbo].[fBusca_Docs_PO_Modal](LEFT(FATURA_PC,16),19) Num_Proc_HBO
				FROM 
					FATURA_CHB FAT
					JOIN FATURA_CHB_ITEM ITM ON ITM.FATURA_CC=FAT.FATURA_PC
					JOIN PESSOA PP ON PP.CD_PES=CD_PES_PC
					LEFT Join Endereco ED on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
					LEFT JOIN MASTER_imp_aer MAS ON MAS.NUM_PROC_mia=LEFT(FATURA_PC,14)
					--LEFT join cta_cte_mas_imp_AER CCM on CCM.num_proc_miA = LEFT(FATURA_PC,14) and CCM.NUM_NF_MIA IS NOT NULL AND CCM.REF_ACESSO_NF_MIA <> 'P' AND CCM.REF_ACESSO_NF_MIA is not null
					join Tipo_Taxa TT on TT.cd_tp_Tx=itm.cd_tp_Tx
					LEft Join PO_Master PO on lefT(fat.fatura_pc,14)=po.num_proC_Master AND ID_DC = 1
					Join Localidade Org on Org.cd_local=cd_org_mia
					Join  Localidade dst on dst.cd_local=cd_dst_mia
					left join Pessoa CNS on CNS.cd_pes = MAS.cd_consig_mia
					Left Join Campo_Processo CP on CP.Num_Proc=left(@Fatura_PC,14) and Id_Campo=25
					Left Join Localidade LDE on LDE.cd_local=CP.Campo_Dados
					Left Join Fatura on fatcod=fatura_pc
					Left Join Tipo_Taxa_PC_CHB TCHB on TCHB.cd_tp_tx=TT.cd_tp_tx and cd_pes_grupo=@cd_pes
				where 
					FATURA_PC=@FATURA_PC and IMPrime='S'
				group by 
					MAS.Num_Proc_MIA,Data_PC,fatdtvenc,obs_PC,obs_mia,right(pp.Num_CPF_CNPJ,14), Fatura_PC,pp.Apelido,pp.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,Mawb_mia ,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, CNS.Nome_Raz_Soc, LDE.Nome_Local,Ordem--NUM_NF_MIA
				Order by order_by
			END		
		end
ELSE
IF @TIPO='F'
	BEGIN
	
		if left(@fatura_pc,2)='BO' and (len(@Fatura_PC) = 17 or len(@fatura_pc)=16)
			BEGIN
				insert @table
					SELECT 
						Top 1
						Data_PC,
						fatDtVenc,
						Obs_PC OBS,
						right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ,
						Fatura_PC,
						PP.Apelido,
						PP.Nome_Raz_Soc,
						RUA,
						Numero,
						Cidade,
						UF,
						max(Numero_PO_HBO) Referencia_Cliente,
						DI_RE_PC,
						''Origem,
						'' Destino,
						'' House,
						NULL CD_TP_TX,
						NULL NOME_TP_TX,
						NULL VLR_PC,
						TP_PGTO,
						'' OBS_HOU,
						CNS.Nome_Raz_Soc CNS,
						LDE.Nome_Local Local_Desemb,
						dbo.fBusca_Tarefa(HOU.Num_Proc_HBO,4) Dt_Desembaraco,
						fatDtVenc Vencimento,
						Max(CCH.Num_NF_HBO) num_nf,
						isnull(Ordem,99) Order_By,[dbo].[fBusca_Docs_PO_Modal](LEFT(FATURA_PC,16),19) Num_Proc_HBO
					FROM 
						FATURA_CHB FAT
						JOIN FATURA_CHB_ITEM ITM ON ITM.FATURA_CC=FAT.FATURA_PC
						JOIN PESSOA PP ON PP.CD_PES=CD_PES_PC 
						LEFT Join Endereco ED on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
						LEFT JOIN House_BDP_OUT HOU ON HOU.Num_Proc_HBO=LEFT(FATURA_PC,16)
						LEFT JOIN Cta_Cte_HOU_BDP_OUT CCH on CCH.Num_Proc_HBO = LEFT(FATURA_PC,16) and CCH.Num_NF_HBO is not null AND CCH.Ref_Acesso_NF_HBO <> 'P' AND CCH.Ref_Acesso_NF_HBO is not null
						join Tipo_Taxa TT on TT.cd_tp_Tx=itm.cd_tp_Tx
						LEft Join PO_HBO PO on lefT(fat.fatura_pc,16)=po.num_proC_HBO AND ID_DC = 1
						--Join Localidade Org on Org.cd_local=cd_org_HEO
						--Join Localidade dst on dst.cd_local=cd_dst_HEO
						left join Pessoa CNS on CNS.cd_pes = HOU.cd_cliente_hbo
						Left Join Campo_Processo CP on CP.Num_Proc=left(@Fatura_PC,16) and Id_Campo=25
						Left Join Localidade LDE on LDE.cd_local=CP.Campo_Dados
						Left Join Fatura on fatcod=fatura_pc
						Left Join Tipo_Taxa_PC_CHB TCHB on TCHB.cd_tp_tx=TT.cd_tp_tx and cd_pes_grupo=@cd_pes
					WHERE 
						FATURA_PC=@FATURA_PC --and imprime='S'
					group by 
						HOU.Num_Proc_HBO, Data_pc,fatdtvenc,Obs_Pc,
						--Obs_Heo,
						right(PP.Num_CPF_CNPJ,14),Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,
						--org.nome_local , dst.nome_local ,hawb_HEO ,
						ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, CNS.Nome_Raz_Soc, LDE.Nome_Local,Ordem
					Order by order_by
			END
	

	    if left(@fatura_pc,2)='EO' and (len(@Fatura_PC) = 17 or len(@fatura_pc)=16)
		BEGIN
			insert @table
			SELECT 
				Top 1
				Data_PC,
				fatDtVenc,
				Obs_PC OBS,
				right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ,
				Fatura_PC,
				PP.Apelido,
				PP.Nome_Raz_Soc,
				RUA,
				Numero,
				Cidade,
				UF,
				max(Numero_PO_HEO) Referencia_Cliente,
				DI_RE_PC,
				org.nome_local Origem,
				dst.nome_local Destino,
				hawb_HEO House,
				NULL CD_TP_TX,
				NULL NOME_TP_TX,
				NULL VLR_PC,
				TP_PGTO,
				Obs_heo OBS_HOU,
				CNS.Nome_Raz_Soc CNS,
				LDE.Nome_Local Local_Desemb,
				dbo.fBusca_Tarefa(HOU.Num_Proc_HEO,4) Dt_Desembaraco,
				fatDtVenc Vencimento,
				Max(CCH.num_nf_heo) num_nf,
				isnull(Ordem,99) Order_By,[dbo].[fBusca_Docs_PO_Modal](LEFT(FATURA_PC,16),19) Num_Proc_HBO
			FROM 
				FATURA_CHB FAT
				JOIN FATURA_CHB_ITEM ITM ON ITM.FATURA_CC=FAT.FATURA_PC
				JOIN PESSOA PP ON PP.CD_PES=CD_PES_PC 
				LEFT Join Endereco ED on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
				LEFT JOIN HOUSE_EXP_OUT HOU ON HOU.NUM_PROC_HEO=LEFT(FATURA_PC,16)
				LEFT JOIN cta_cte_hou_exp_out CCH on CCH.num_proc_heo = LEFT(FATURA_PC,16) and CCH.num_nf_heo is not null AND CCH.REF_ACESSO_NF_Heo <> 'P' AND CCH.REF_ACESSO_NF_Heo is not null
				join Tipo_Taxa TT on TT.cd_tp_Tx=itm.cd_tp_Tx
				LEft Join PO_HEO PO on lefT(fat.fatura_pc,16)=po.num_proC_HEO AND ID_DC = 1
				Join Localidade Org on Org.cd_local=cd_org_HEO
				Join Localidade dst on dst.cd_local=cd_dst_HEO
				left join Pessoa CNS on CNS.cd_pes = HOU.cd_export_HEO
				Left Join Campo_Processo CP on CP.Num_Proc=left(@Fatura_PC,16) and Id_Campo=25
				Left Join Localidade LDE on LDE.cd_local=CP.Campo_Dados
				Left Join Fatura on fatcod=fatura_pc
				Left Join Tipo_Taxa_PC_CHB TCHB on TCHB.cd_tp_tx=TT.cd_tp_tx and cd_pes_grupo=@cd_pes
			WHERE 
				FATURA_PC=@FATURA_PC --and imprime='S'
			group by 
				HOU.Num_Proc_HEO, Data_pc,fatdtvenc,Obs_Pc,Obs_Heo,right(PP.Num_CPF_CNPJ,14),Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,hawb_HEO ,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, CNS.Nome_Raz_Soc, LDE.Nome_Local,Ordem
			Order by order_by
		END

	    if left(@fatura_pc,2)='IO' and (len(@Fatura_PC) = 17 or len(@fatura_pc)=16)
		BEGIN
		insert @table
			SELECT 
				Top 1
				Data_PC,fatdtvenc,Obs_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ ,Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,RUA,Numero,Cidade,UF,max(Numero_PO_HIO) Referencia_Cliente,DI_RE_PC,org.nome_local Origem, dst.nome_local Destino,hawb_HIO House,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO,Obs_hio OBS_HOU, CNS.Nome_Raz_Soc CNS, LDE.Nome_Local Local_Desemb,
				dbo.fBusca_Tarefa(HOU.Num_Proc_HIO,4) Dt_Desembaraco,fatDtVenc Vencimento, MAx(cch.num_nf_hio) num_nf,isnull(Ordem,99) Order_By,[dbo].[fBusca_Docs_PO_Modal](LEFT(FATURA_PC,16),19) Num_Proc_HBO
			FROM 
				FATURA_CHB FAT
				JOIN FATURA_CHB_ITEM ITM ON ITM.FATURA_CC=FAT.FATURA_PC
				JOIN PESSOA PP ON PP.CD_PES=CD_PES_PC 
				LEFT Join Endereco ED on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
				LEFT JOIN HOUSE_IMP_OUT HOU ON HOU.NUM_PROC_HIO=LEFT(FATURA_PC,16)
				LEFT JOIN cta_cte_hou_imp_out CCH on CCH.num_proc_hio = LEFT(FATURA_PC,16) and CCH.num_nf_hio is not null AND CCH.REF_ACESSO_NF_HIo <> 'P' AND CCH.REF_ACESSO_NF_Hio is not null
				join Tipo_Taxa TT on TT.cd_tp_Tx=itm.cd_tp_Tx
				LEft Join PO_HIO PO on lefT(fat.fatura_pc,16)=po.num_proC_HIO AND ID_DC = 1
				Join Localidade Org on Org.cd_local=cd_org_HIO
				Join Localidade dst on dst.cd_local=cd_dst_HIO
				left join Pessoa CNS on CNS.cd_pes = HOU.cd_consig_HIO
				Left Join Campo_Processo CP on CP.Num_Proc=left(@Fatura_PC,16) and Id_Campo=25
				Left Join Localidade LDE on LDE.cd_local=CP.Campo_Dados
				Left Join Fatura on fatcod=fatura_pc
				Left Join Tipo_Taxa_PC_CHB TCHB on TCHB.cd_tp_tx=TT.cd_tp_tx and cd_pes_grupo=@cd_pes
			WHERE 
				FATURA_PC=@FATURA_PC --and imprime='S'
			group by 
				HOU.Num_Proc_HIO,Data_PC,fatdtvenc,Obs_PC,obs_hio,right(PP.Num_CPF_CNPJ,14),Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,hawb_HIO ,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, CNS.Nome_Raz_Soc, LDE.Nome_Local,Ordem
			Order by order_by
		END

	    if left(@fatura_pc,2)='IM' and (len(@Fatura_PC) = 17 or len(@Fatura_PC) = 16)
		BEGIN
			insert @table
			SELECT 
				Top 1
				Data_PC,fatdtvenc,OBS_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ ,Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,RUA,Numero,Cidade,UF,max(Numero_PO_HIM) Referencia_Cliente,DI_RE_PC,org.nome_local Origem, dst.nome_local Destino,hawb_him House,NULL CD_TP_TX,NULL NOME_TP_TX,NULL VLR_PC, TP_PGTO, Obs_him OBS_HOU, CNS.Nome_Raz_Soc CNS, LDE.Nome_Local Local_Desemb,
				dbo.fBusca_Tarefa(HOU.Num_Proc_HIM,4) Dt_Desembaraco,fatDtVenc Vencimento,max(CCH.num_nf_him) num_nf,isnull(Ordem,99) Order_By,[dbo].[fBusca_Docs_PO_Modal](LEFT(FATURA_PC,16),19) Num_Proc_HBO
			FROM 
				FATURA_CHB FAT
				JOIN FATURA_CHB_ITEM ITM ON ITM.FATURA_CC=FAT.FATURA_PC
				JOIN PESSOA PP ON PP.CD_PES=CD_PES_PC
				LEFT Join Endereco ED on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
				LEFT JOIN HOUSE_IMP_MAR HOU ON HOU.NUM_PROC_HIM=LEFT(FATURA_PC,16)
				LEFT JOIN cta_cte_hou_imp_mar CCH on CCH.num_proc_him = LEFT(FATURA_PC,16) and CCH.num_nf_him is not null AND CCH.REF_ACESSO_NF_HIM <> 'P' AND CCH.REF_ACESSO_NF_Him is not null
				join Tipo_Taxa TT on TT.cd_tp_Tx=itm.cd_tp_Tx
				LEft Join PO_HIM PO on lefT(fat.fatura_pc,16)=po.num_proC_him AND ID_DC = 1
				Join Localidade Org on Org.cd_local=cd_org_him
				Join Localidade dst on dst.cd_local=cd_dst_him
				left join Pessoa CNS on CNS.cd_pes = HOU.cd_consig_HIM
				Left Join Campo_Processo CP on CP.Num_Proc=left(@Fatura_PC,16) and Id_Campo=25
				Left Join Localidade LDE on LDE.cd_local=CP.Campo_Dados
				Left Join Fatura on fatcod=fatura_pc
				Left Join Tipo_Taxa_PC_CHB TCHB on TCHB.cd_tp_tx=TT.cd_tp_tx and cd_pes_grupo=@cd_pes
			WHERE 
				FATURA_PC=@FATURA_PC-- and imprime='S'
			group by 
				HOU.Num_Proc_HIM,Data_PC,fatdtvenc,Obs_PC,obs_him,right(pp.Num_CPF_CNPJ,14),Fatura_PC,pp.Apelido,pp.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,hawb_him ,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, CNS.Nome_Raz_Soc, LDE.Nome_Local,Ordem
			Order by order_by
			END
		
		IF left(@fatura_pc,2)='IA' and (len(@Fatura_PC) = 17 or len(@fatura_pc)=16)
			BEGIN
				insert @table
				SELECT Top 1
					Data_PC,fatdtvenc,Obs_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ, Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,RUA,Numero,Cidade,UF, max(Numero_PO_hia) Referencia_Cliente,DI_RE_PC,org.nome_local Origem, dst.nome_local Destino,hawb_hia House,NULL CD_TP_TX,NULL NOME_TP_TX,NULL VLR_PC, TP_PGTO, Obs_hia OBS_HOU, CNS.Nome_Raz_Soc CNS, LDE.Nome_Local Local_Desemb,
					dbo.fBusca_Tarefa(HOU.Num_Proc_HIA,4) Dt_Desembaraco,fatDtVenc Vencimento, Max(cch.num_nf_hia) num_nf,isnull(Ordem,99) Order_By,[dbo].[fBusca_Docs_PO_Modal](LEFT(FATURA_PC,16),19) Num_Proc_HBO
				FROM 
					FATURA_CHB FAT
					JOIN FATURA_CHB_ITEM ITM ON ITM.FATURA_CC=FAT.FATURA_PC
					JOIN PESSOA PP ON PP.CD_PES=CD_PES_PC
					LEFT Join Endereco ED on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
					LEFT JOIN HOUSE_IMP_aer HOU ON HOU.NUM_PROC_hia=LEFT(FATURA_PC,16)
					LEFT JOIN cta_cte_hou_imp_aer CCH on CCH.num_proc_hia = LEFT(FATURA_PC,16) and CCH.num_nf_hia is not null AND CCH.REF_ACESSO_NF_HIa <> 'P' AND CCH.REF_ACESSO_NF_Hia is not null
					join Tipo_Taxa TT on TT.cd_tp_Tx=itm.cd_tp_Tx
					LEft Join PO_hia PO on lefT(fat.fatura_pc,16)=po.num_proC_hia  AND ID_DC = 1
					Join Localidade Org on Org.cd_local=cd_org_hia
					Join Localidade dst on dst.cd_local=cd_dst_hia
					left join Pessoa CNS on CNS.cd_pes = HOU.cd_consig_HIA
					Left Join Campo_Processo CP on CP.Num_Proc=left(@Fatura_PC,16) and Id_Campo=25
					Left Join Localidade LDE on LDE.cd_local=CP.Campo_Dados
					Left Join Fatura on fatcod=fatura_pc
					Left Join Tipo_Taxa_PC_CHB TCHB on TCHB.cd_tp_tx=TT.cd_tp_tx and cd_pes_grupo=@cd_pes
				WHERE 
					FATURA_PC=@FATURA_PC-- and imprime='S'
				group by 
					HOU.Num_Proc_HIA,Data_PC,fatdtvenc,obs_PC,obs_hia,right(pp.Num_CPF_CNPJ,14), Fatura_PC,pp.Apelido,pp.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,hawb_hia ,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, CNS.Nome_Raz_Soc, LDE.Nome_Local,Ordem
				Order by order_by
			END		
		IF left(@fatura_pc,2)='EM' and (len(@Fatura_PC) = 17 or len(@fatura_pc)=16)
			BEGIN
				insert @table
				SELECT Top 1
					Data_PC,fatdtvenc,OBS_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ ,Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,RUA,Numero,Cidade,UF,max(Numero_PO_HEM) Referencia_Cliente,DI_RE_PC,org.nome_local Origem, dst.nome_local Destino,hawb_HEM House,NULL CD_TP_TX,NULL NOME_TP_TX,NULL VLR_PC, TP_PGTO, Obs_hem OBS_HOU, CNS.Nome_Raz_Soc CNS, LDE.Nome_Local Local_Desemb,
					dbo.fBusca_Tarefa(HOU.Num_Proc_HEM,4) Dt_Desembaraco,fatDtVenc Vencimento, max(cch.num_nf_hem) num_nf,isnull(Ordem,99) Order_By,[dbo].[fBusca_Docs_PO_Modal](LEFT(FATURA_PC,16),19) Num_Proc_HBO
				FROM 
					FATURA_CHB FAT
					JOIN FATURA_CHB_ITEM ITM ON ITM.FATURA_CC=FAT.FATURA_PC
					JOIN PESSOA PP ON PP.CD_PES=CD_PES_PC
					LEFT Join Endereco ED on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
					LEFT JOIN HOUSE_EXP_MAR HOU ON HOU.NUM_PROC_HEM=LEFT(FATURA_PC,16)
					LEFT JOIN cta_cte_hou_exp_mar CCH on CCH.num_proc_hem = LEFT(FATURA_PC,16) 
					and CCH.num_nf_hem is not null AND CCH.REF_ACESSO_NF_HeM <> 'P'
					join Tipo_Taxa TT on TT.cd_tp_Tx=itm.cd_tp_Tx
					LEft Join PO_HEM PO on lefT(fat.fatura_pc,16)=po.num_proC_HEM AND ID_DC = 1
					Join Localidade Org on Org.cd_local=cd_org_HEM
					Join Localidade dst on dst.cd_local=cd_dst_HEM
					left join Pessoa CNS on CNS.cd_pes = HOU.cd_export_HEM
					Left Join Campo_Processo CP on CP.Num_Proc=left(@Fatura_PC,16) and Id_Campo=25
					Left Join Localidade LDE on LDE.cd_local=CP.Campo_Dados
					Left Join Fatura on fatcod=fatura_pc
					Left Join Tipo_Taxa_PC_CHB TCHB on TCHB.cd_tp_tx=TT.cd_tp_tx and cd_pes_grupo=@cd_pes
				WHERE 
					FATURA_PC=@FATURA_PC --and IMPrime='S'
				group by 
					HOU.Num_Proc_HEM,Data_PC,fatdtvenc,OBS_PC,obs_hem,right(pp.Num_CPF_CNPJ,14),Fatura_PC,pp.Apelido,pp.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,hawb_HEM ,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, CNS.Nome_Raz_Soc, LDE.Nome_Local,Ordem
				Order by order_by
			END
		
		IF left(@fatura_pc,2)='EA' and (len(@Fatura_PC) = 17 or len(@fatura_pc)=16)
			BEGIN
			insert @table
				SELECT Top 1
					Data_PC,fatdtvenc,obs_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ, Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,RUA,Numero,Cidade,UF,max(Numero_PO_HEA) Referencia_Cliente,DI_RE_PC,org.nome_local Origem, dst.nome_local Destino,hawb_HEA House,NULL CD_TP_TX,NULL NOME_TP_TX,NULL VLR_PC, TP_PGTO, Obs_hea OBS_HOU, CNS.Nome_Raz_Soc CNS, LDE.Nome_Local Local_Desemb,
					dbo.fBusca_Tarefa(HOU.Num_Proc_HEA,4) Dt_Desembaraco,fatDtVenc Vencimento, Max(CCH.num_nf_hea) num_nf,isnull(Ordem,99) Order_By,[dbo].[fBusca_Docs_PO_Modal](LEFT(FATURA_PC,16),19) Num_Proc_HBO
				FROM 
					FATURA_CHB FAT
					JOIN FATURA_CHB_ITEM ITM ON ITM.FATURA_CC=FAT.FATURA_PC
					JOIN PESSOA PP ON PP.CD_PES=CD_PES_PC
					LEFT Join Endereco ED on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
					LEFT JOIN HOUSE_EXP_aer HOU ON HOU.NUM_PROC_HEA=LEFT(FATURA_PC,16)
					LEFT JOIN cta_cte_hou_exp_aer CCH on CCH.num_proc_hea = LEFT(FATURA_PC,16) and CCH.num_nf_hea is not null AND CCH.REF_ACESSO_NF_Hea <> 'P' AND CCH.REF_ACESSO_NF_Hea is not null
					join Tipo_Taxa TT on TT.cd_tp_Tx=itm.cd_tp_Tx
					LEft Join PO_HEA PO on lefT(fat.fatura_pc,16)=po.num_proC_HEA AND ID_DC = 1
					Join Localidade Org on Org.cd_local=cd_org_HEA
					Join  Localidade dst on dst.cd_local=cd_dst_HEA
					left join Pessoa CNS on CNS.cd_pes = HOU.cd_export_HEA
					Left Join Campo_Processo CP on CP.Num_Proc=left(@Fatura_PC,16) and Id_Campo=25
					Left Join Localidade LDE on LDE.cd_local=CP.Campo_Dados
					Left Join Fatura on fatcod=fatura_pc
					Left Join Tipo_Taxa_PC_CHB TCHB on TCHB.cd_tp_tx=TT.cd_tp_tx and cd_pes_grupo=@cd_pes
				where 
					FATURA_PC=@FATURA_PC-- and IMPrime='S'
				group by 
					HOU.Num_Proc_HEA,Data_PC,fatdtvenc,obs_PC,obs_hea,right(pp.Num_CPF_CNPJ,14), Fatura_PC,pp.Apelido,pp.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,hawb_HEA ,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, CNS.Nome_Raz_Soc, LDE.Nome_Local,Ordem
				Order by order_by
			END

		IF left(@fatura_pc,2)='EA' and (len(@Fatura_PC) = 15 or len(@fatura_pc)=14)
		
			BEGIN
			insert @table
				SELECT Top 1
					Data_PC,fatdtvenc,obs_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ, Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,RUA,Numero,Cidade,UF,max(Numero_PO) Referencia_Cliente,DI_RE_PC,org.nome_local Origem, dst.nome_local Destino,Mawb_MEA HOUSE,NULL CD_TP_TX,NULL NOME_TP_TX,NULL VLR_PC, TP_PGTO, Obs_MEA OBS_MAS, CNS.Nome_Raz_Soc CNS, LDE.Nome_Local Local_Desemb,
					dbo.fBusca_Tarefa(MAS.Num_Proc_MEA,4) Dt_Desembaraco,fatDtVenc Vencimento, 
					--MAx(CCM.NUM_NF_MeA)) num_nf
					(select max(num_nf_mea) from cta_cte_mas_exp_aer where num_proc_mea = LEFT(FATURA_PC,14)) num_nf,isnull(Ordem,99) Order_By,[dbo].[fBusca_Docs_PO_Modal](LEFT(FATURA_PC,16),19) Num_Proc_HBO
				FROM 
					FATURA_CHB FAT
					JOIN FATURA_CHB_ITEM ITM ON ITM.FATURA_CC=FAT.FATURA_PC
					JOIN PESSOA PP ON PP.CD_PES=CD_PES_PC
					LEFT Join Endereco ED on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
					LEFT JOIN MASTER_EXP_aer MAS ON MAS.NUM_PROC_MEA=LEFT(FATURA_PC,14)
					--LEFT join cta_cte_mas_exp_AER CCM on CCM.num_proc_meA = LEFT(FATURA_PC,14) and CCM.NUM_NF_MeA IS NOT NULL AND CCM.REF_ACESSO_NF_MeA <> 'P' AND CCM.REF_ACESSO_NF_MEA is not null
					join Tipo_Taxa TT on TT.cd_tp_Tx=itm.cd_tp_Tx
					LEft Join PO_Master PO on lefT(fat.fatura_pc,14)=po.num_proC_Master AND ID_DC = 1
					Join Localidade Org on Org.cd_local=cd_org_MEA
					Join  Localidade dst on dst.cd_local=cd_dst_MEA
					left join Pessoa CNS on CNS.cd_pes = MAS.cd_export_MEA
					Left Join Campo_Processo CP on CP.Num_Proc=left(@Fatura_PC,14) and Id_Campo=25
					Left Join Localidade LDE on LDE.cd_local=CP.Campo_Dados
					Left Join Fatura on fatcod=fatura_pc
					Left Join Tipo_Taxa_PC_CHB TCHB on TCHB.cd_tp_tx=TT.cd_tp_tx and cd_pes_grupo=@cd_pes
				where 
					FATURA_PC=@FATURA_PC --and IMPrime='S'
				group by 
					MAS.Num_Proc_MEA,Data_PC,fatdtvenc,obs_PC,obs_MEA,right(pp.Num_CPF_CNPJ,14), Fatura_PC,pp.Apelido,pp.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,Mawb_MEA ,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, CNS.Nome_Raz_Soc, LDE.Nome_Local,Ordem
				Order by order_by
			END
		IF left(@fatura_pc,2)='EM' and (len(@Fatura_PC) = 15 or len(@fatura_pc)=14)
		
			BEGIN
			insert @table
				SELECT Top 1
					Data_PC,fatdtvenc,obs_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ, Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,RUA,Numero,Cidade,UF,max(Numero_PO) Referencia_Cliente,DI_RE_PC,org.nome_local Origem, dst.nome_local Destino,Mawb_mem HOUSE,NULL CD_TP_TX,NULL NOME_TP_TX,NULL VLR_PC, TP_PGTO, Obs_mem OBS_MAS, CNS.Nome_Raz_Soc CNS, LDE.Nome_Local Local_Desemb,
					dbo.fBusca_Tarefa(MAS.Num_Proc_MEM,4) Dt_Desembaraco,fatDtVenc Vencimento, 
					--Max(CCM.NUM_NF_Mem) num_nf
					(select max(num_nf_mem) from cta_cte_mas_exp_mar where num_proc_mem = LEFT(FATURA_PC,14)) num_nf,isnull(Ordem,99) Order_By,[dbo].[fBusca_Docs_PO_Modal](LEFT(FATURA_PC,16),19) Num_Proc_HBO
				FROM
					FATURA_CHB FAT
					JOIN FATURA_CHB_ITEM ITM ON ITM.FATURA_CC=FAT.FATURA_PC
					JOIN PESSOA PP ON PP.CD_PES=CD_PES_PC
					LEFT Join Endereco ED on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
					LEFT JOIN MASTER_EXP_mar MAS ON MAS.NUM_PROC_mem=LEFT(FATURA_PC,14)
					--LEFT join cta_cte_mas_exp_mar CCM on CCM.num_proc_mem = LEFT(FATURA_PC,14) and CCM.NUM_NF_MeM IS NOT NULL AND CCM.REF_ACESSO_NF_MeM <> 'P' AND CCM.REF_ACESSO_NF_MEM is not null
					join Tipo_Taxa TT on TT.cd_tp_Tx=itm.cd_tp_Tx
					LEft Join PO_Master PO on lefT(fat.fatura_pc,14)=po.num_proC_Master AND ID_DC = 1
					Join Localidade Org on Org.cd_local=cd_org_mem
					Join  Localidade dst on dst.cd_local=cd_dst_mem
					left join Pessoa CNS on CNS.cd_pes = MAS.cd_export_mem
					Left Join Campo_Processo CP on CP.Num_Proc=left(@Fatura_PC,14) and Id_Campo=25
					Left Join Localidade LDE on LDE.cd_local=CP.Campo_Dados
					Left Join Fatura on fatcod=fatura_pc
					Left Join Tipo_Taxa_PC_CHB TCHB on TCHB.cd_tp_tx=TT.cd_tp_tx and cd_pes_grupo=@cd_pes
				where 
					FATURA_PC=@FATURA_PC --and IMPrime='S'
				group by 
					MAS.Num_Proc_MEM,Data_PC,fatdtvenc,obs_PC,obs_mem,right(pp.Num_CPF_CNPJ,14), Fatura_PC,pp.Apelido,pp.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,Mawb_mem ,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, CNS.Nome_Raz_Soc, LDE.Nome_Local,Ordem
				Order by order_by
			END
		IF left(@fatura_pc,2)='IM' and (len(@Fatura_PC) = 15 OR len(@Fatura_PC) = 14)
			BEGIN
			insert @table
				SELECT Top 1
					Data_PC,fatdtvenc,obs_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ, Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,RUA,Numero,Cidade,UF,max(Numero_PO) Referencia_Cliente,DI_RE_PC,org.nome_local Origem, dst.nome_local Destino,Mawb_mim HOUSE,NULL CD_TP_TX,NULL NOME_TP_TX,NULL VLR_PC, TP_PGTO, Obs_mim OBS_MAS, CNS.Nome_Raz_Soc CNS, LDE.Nome_Local Local_Desemb, 
					dbo.fBusca_Tarefa(MAS.Num_Proc_MIM,4) Dt_Desembaraco,fatDtVenc Vencimento,
					--max(CCM.NUM_NF_MIM) num_nf
					(select max(num_nf_mim) from cta_cte_mas_imp_mar where num_proc_mim = LEFT(FATURA_PC,14)) num_nf,isnull(Ordem,99) Order_By,[dbo].[fBusca_Docs_PO_Modal](LEFT(FATURA_PC,16),19) Num_Proc_HBO
				FROM 
					FATURA_CHB FAT
					JOIN FATURA_CHB_ITEM ITM ON ITM.FATURA_CC=FAT.FATURA_PC
					JOIN PESSOA PP ON PP.CD_PES=CD_PES_PC
					LEFT Join Endereco ED on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
					LEFT JOIN MASTER_imp_mar MAS ON MAS.NUM_PROC_mim=LEFT(FATURA_PC,14)
					--LEFT join cta_cte_mas_imp_mar CCM on CCM.num_proc_mim = LEFT(FATURA_PC,14) and CCM.NUM_NF_MIM IS NOT NULL AND CCM.REF_ACESSO_NF_MIM <> 'P' AND CCM.REF_ACESSO_NF_MIM is not null
					join Tipo_Taxa TT on TT.cd_tp_Tx=itm.cd_tp_Tx
					LEft Join PO_Master PO on lefT(fat.fatura_pc,14)=po.num_proC_Master AND ID_DC = 1
					Join Localidade Org on Org.cd_local=cd_org_mim
					Join  Localidade dst on dst.cd_local=cd_dst_mim
					left join Pessoa CNS on CNS.cd_pes = MAS.cd_consig_mim
					Left Join Campo_Processo CP on CP.Num_Proc=left(@Fatura_PC,14) and Id_Campo=25
					Left Join Localidade LDE on LDE.cd_local=CP.Campo_Dados
					Left Join Fatura on fatcod=fatura_pc
					Left Join Tipo_Taxa_PC_CHB TCHB on TCHB.cd_tp_tx=TT.cd_tp_tx and cd_pes_grupo=@cd_pes
				where 
					FATURA_PC=@FATURA_PC --and IMPrime='S'
				group by 
					MAS.Num_Proc_MIM,Data_PC,fatdtvenc,obs_PC,obs_mim,right(pp.Num_CPF_CNPJ,14), Fatura_PC,pp.Apelido,pp.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,Mawb_mim ,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, CNS.Nome_Raz_Soc, LDE.Nome_Local,Ordem--,NUM_NF_MIM
				Order by order_by
			END
		IF left(@fatura_pc,2)='IA' and (len(@Fatura_PC) = 15 or len(@fatura_pc)=14)

			BEGIN
			insert @table
				SELECT Top 1
					Data_PC,fatdtvenc,obs_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ, Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,RUA,Numero,Cidade,UF,max(Numero_PO) Referencia_Cliente,DI_RE_PC,org.nome_local Origem, dst.nome_local Destino,Mawb_mia HOUSE,NULL CD_TP_TX,NULL NOME_TP_TX,NULL VLR_PC, TP_PGTO, Obs_mia OBS_MAS, CNS.Nome_Raz_Soc CNS, LDE.Nome_Local Local_Desemb,
					dbo.fBusca_Tarefa(MAS.Num_Proc_MIA,4) Dt_Desembaraco ,fatDtVenc Vencimento,
--					max(CCM.NUM_NF_MIA) num_nf
					(select max(num_nf_mia) from cta_cte_mas_imp_aer where num_proc_mia = LEFT(FATURA_PC,14)) num_nf,isnull(Ordem,99) Order_By,[dbo].[fBusca_Docs_PO_Modal](LEFT(FATURA_PC,16),19) Num_Proc_HBO
				FROM 
					FATURA_CHB FAT
					JOIN FATURA_CHB_ITEM ITM ON ITM.FATURA_CC=FAT.FATURA_PC
					JOIN PESSOA PP ON PP.CD_PES=CD_PES_PC
					LEFT Join Endereco ED on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
					LEFT JOIN MASTER_imp_aer MAS ON MAS.NUM_PROC_mia=LEFT(FATURA_PC,14)
					--LEFT join cta_cte_mas_imp_AER CCM on CCM.num_proc_miA = LEFT(FATURA_PC,14) and CCM.NUM_NF_MIA IS NOT NULL AND CCM.REF_ACESSO_NF_MIA <> 'P' AND CCM.REF_ACESSO_NF_MIA is not null
					join Tipo_Taxa TT on TT.cd_tp_Tx=itm.cd_tp_Tx
					LEft Join PO_Master PO on lefT(fat.fatura_pc,14)=po.num_proC_Master AND ID_DC = 1
					Join Localidade Org on Org.cd_local=cd_org_mia
					Join  Localidade dst on dst.cd_local=cd_dst_mia
					left join Pessoa CNS on CNS.cd_pes = MAS.cd_consig_mia
					Left Join Campo_Processo CP on CP.Num_Proc=left(@Fatura_PC,14) and Id_Campo=25
					Left Join Localidade LDE on LDE.cd_local=CP.Campo_Dados
					Left Join Fatura on fatcod=fatura_pc
					Left Join Tipo_Taxa_PC_CHB TCHB on TCHB.cd_tp_tx=TT.cd_tp_tx and cd_pes_grupo=@cd_pes
				where 
					FATURA_PC=@FATURA_PC --and IMPrime='S'
				group by 
					MAS.Num_Proc_MIA,Data_PC,fatdtvenc,obs_PC,obs_mia,right(pp.Num_CPF_CNPJ,14), Fatura_PC,pp.Apelido,pp.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,Mawb_mia ,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, CNS.Nome_Raz_Soc, LDE.Nome_Local,Ordem--NUM_NF_MIA
				Order by order_by
			END		
		end
ELSE
	BEGIN
	
		IF left(@fatura_pc,2)='BO' and len(@fatura_pc)=17
			BEGIN
			insert @table
				SELECT 
					Data_PC,fatdtvenc,obs_pc OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ, Fatura_PC,PP.Apelido,
					PP.Nome_Raz_Soc,RUA,Numero,Cidade,UF,max(Numero_PO_HBO) Referencia_Cliente,DI_RE_PC,
					'' Origem, 
					'' Destino,
					'' House,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, 
					'' OBS_HOU, CNS.Nome_raz_soc CNS, LDE.Nome_Local Local_Desemb,
					dbo.fBusca_Tarefa(HOU.Num_Proc_HBO,4) Dt_Desembaraco, fatDtVenc Vencimento, CCH.Num_NF_HBO num_nf,isnull(Ordem,99) Order_By,[dbo].[fBusca_Docs_PO_Modal](LEFT(FATURA_PC,16),19) Num_Proc_HBO
				FROM 
					FATURA_CHB FAT
					JOIN FATURA_CHB_ITEM ITM ON ITM.FATURA_CC=FAT.FATURA_PC
					JOIN PESSOA PP ON PP.CD_PES=CD_PES_PC
					LEFT Join Endereco ED on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
					LEFT JOIN House_BDP_OUT HOU ON HOU.Num_Proc_HBO=LEFT(FATURA_PC,16)
					LEFT JOIN Cta_Cte_HOU_BDP_OUT CCH on CCH.Num_Proc_HBO = LEFT(FATURA_PC,16) and CCH.Num_NF_HBO is not null AND CCH.Ref_Acesso_NF_HBO <> 'P' AND CCH.Ref_Acesso_NF_HBO is not null
					join Tipo_Taxa TT on TT.cd_tp_Tx=itm.cd_tp_Tx
					LEft Join PO_HBO PO on lefT(fat.fatura_pc,16)=po.Num_Proc_HBO AND ID_DC = 1
					--Left Join Localidade Org on Org.cd_local=cd_org_HEO
					--Left Join Localidade dst on dst.cd_local=cd_dst_HEO
					left join Pessoa CNS on CNS.cd_pes = HOU.cd_cliente_hbo
					Left Join Campo_Processo CP on CP.Num_Proc=left(@Fatura_PC,16) and Id_Campo=25
					Left Join Localidade LDE on LDE.cd_local=CP.Campo_Dados
					Left Join Fatura on fatcod=fatura_pc
					Left Join Tipo_Taxa_PC_CHB TCHB on TCHB.cd_tp_tx=TT.cd_tp_tx and cd_pes_grupo=@cd_pes
				WHERE 
					FATURA_PC=@FATURA_PC 
				group by 
					HOU.Num_Proc_HBO,Data_PC,fatdtvenc,obs_pc,
					--obs_heo,
					right(pp.Num_CPF_CNPJ,14), Fatura_PC,pp.Apelido,pp.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,
					--org.nome_local , dst.nome_local ,hawb_HEO ,
					ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, CNS.Nome_raz_Soc, LDE.Nome_Local,Num_NF_HBO,Ordem
				Order by order_by
			END
	
		IF left(@fatura_pc,2)='IM' and (len(@fatura_pc)=17 or len(@fatura_pc)=16)
			BEGIN
			insert @table
				SELECT 
					Data_PC,fatdtvenc,OBS_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ, Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,RUA,Numero,Cidade,UF,max(Numero_PO_HIM) Referencia_Cliente,DI_RE_PC,org.nome_local Origem, dst.nome_local Destino,hawb_him House,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, Obs_him OBS_HOU, CNS.Nome_Raz_Soc CNS, LDE.Nome_Local Local_Desemb,
					dbo.fBusca_Tarefa(HOU.Num_Proc_HIM,4) Dt_Desembaraco,fatDtVenc Vencimento,MAX(CCH.NUM_NF_HIM) num_nf,isnull(Ordem,99) Order_By,[dbo].[fBusca_Docs_PO_Modal](LEFT(FATURA_PC,16),19) Num_Proc_HBO
				FROM 
					FATURA_CHB FAT
					JOIN FATURA_CHB_ITEM ITM ON ITM.FATURA_CC=FAT.FATURA_PC
					JOIN PESSOA PP ON PP.CD_PES=CD_PES_PC
					LEFT Join Endereco ED on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
					LEFT JOIN HOUSE_IMP_MAR HOU ON HOU.NUM_PROC_HIM=LEFT(FATURA_PC,16)
					LEFT JOIN cta_cte_hou_imp_mar CCH on CCH.num_proc_him = LEFT(FATURA_PC,16) and CCH.num_nf_him is not null AND CCH.REF_ACESSO_NF_HIM <> 'P' AND CCH.REF_ACESSO_NF_Him is not null
					join Tipo_Taxa TT on TT.cd_tp_Tx=itm.cd_tp_Tx
					LEft Join PO_HIM PO on lefT(fat.fatura_pc,16)=po.num_proC_him AND ID_DC = 1
					Join Localidade Org on Org.cd_local=cd_org_him
					Join Localidade dst on dst.cd_local=cd_dst_him
					left join Pessoa CNS on CNS.cd_pes = HOU.cd_consig_HIM
					Left Join Campo_Processo CP on CP.Num_Proc=left(@Fatura_PC,16) and Id_Campo=25
					Left Join Localidade LDE on LDE.cd_local=CP.Campo_Dados
					Left Join Fatura on fatcod=fatura_pc
					Left Join Tipo_Taxa_PC_CHB TCHB on TCHB.cd_tp_tx=TT.cd_tp_tx and cd_pes_grupo=@cd_pes
				WHERE 
					FATURA_PC=@FATURA_PC 
				group by 
					HOU.Num_Proc_HIM,Data_PC,fatdtvenc,Obs_PC,obs_him,right(pp.Num_CPF_CNPJ,14), Fatura_PC,pp.Apelido,pp.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,hawb_him ,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, CNS.Nome_Raz_Soc, LDE.Nome_Local,Ordem
				Order by order_by
			End

		IF left(@fatura_pc,2)='IA' and (len(@fatura_pc)=17 or len(@fatura_pc)=16)
			BEGIN
			insert @table
				SELECT 
					Data_PC,fatdtvenc,Obs_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ, Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,RUA,Numero,Cidade,UF,max(Numero_PO_hia) Referencia_Cliente,DI_RE_PC,org.nome_local Origem, dst.nome_local Destino,hawb_hia House,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, Obs_hia OBS_HOU, CNS.Nome_Raz_Soc CNS, LDE.Nome_Local Local_Desemb,
					dbo.fBusca_Tarefa(HOU.Num_Proc_HIA,4) Dt_Desembaraco,fatDtVenc Vencimento, max(CCH.num_nf_hia) num_nf,isnull(Ordem,99) Order_By,[dbo].[fBusca_Docs_PO_Modal](LEFT(FATURA_PC,16),19) Num_Proc_HBO
				FROM 
					FATURA_CHB FAT
					JOIN FATURA_CHB_ITEM ITM ON ITM.FATURA_CC=FAT.FATURA_PC
					JOIN PESSOA PP ON PP.CD_PES=CD_PES_PC
					LEFT Join Endereco ED on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
					LEFT JOIN HOUSE_IMP_aer HOU ON HOU.NUM_PROC_hia=LEFT(FATURA_PC,16)
					LEFT JOIN cta_cte_hou_imp_aer CCH on CCH.num_proc_hia = LEFT(FATURA_PC,16) and CCH.num_nf_hia is not null AND CCH.REF_ACESSO_NF_HIa <> 'P' AND CCH.REF_ACESSO_NF_Hia is not null
					join Tipo_Taxa TT on TT.cd_tp_Tx=itm.cd_tp_Tx
					LEft Join PO_hia PO on lefT(fat.fatura_pc,16)=po.num_proC_hia AND ID_DC=1
					Left Join Localidade Org on Org.cd_local=cd_org_hia
					Left Join Localidade dst on dst.cd_local=cd_dst_hia
					left join Pessoa CNS on CNS.cd_pes = HOU.cd_consig_HIA
					Left Join Campo_Processo CP on CP.Num_Proc=left(@Fatura_PC,16) and Id_Campo=25
					Left Join Localidade LDE on LDE.cd_local=CP.Campo_Dados
					Left Join Fatura on fatcod=fatura_pc
					Left Join Tipo_Taxa_PC_CHB TCHB on TCHB.cd_tp_tx=TT.cd_tp_tx and cd_pes_grupo=@cd_pes
				WHERE 
					FATURA_PC=@FATURA_PC 
				group by 
					HOU.Num_Proc_HIA,Data_PC,fatdtvenc,Obs_PC,obs_hia,right(pp.Num_CPF_CNPJ,14), Fatura_PC,pp.Apelido,pp.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,hawb_hia ,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, CNS.Nome_Raz_Soc, LDE.Nome_Local,Ordem
				Order by order_by
			END
		
		IF left(@fatura_pc,2)='EM' and len(@fatura_pc)=17
			BEGIN
			insert @table
				SELECT 
					Data_PC,fatdtvenc,OBS_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ, Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,RUA,Numero,Cidade,UF,max(Numero_PO_HEM) Referencia_Cliente,DI_RE_PC,org.nome_local Origem, dst.nome_local Destino,hawb_HEM House,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, Obs_hem OBS_HOU, CNS.Nome_raz_Soc CNS, LDE.Nome_Local Local_Desemb,
					dbo.fBusca_Tarefa(HOU.Num_Proc_HEM,4) Dt_Desembaraco ,fatDtVenc Vencimento,max(CCH.num_nf_hem) num_nf,isnull(Ordem,99) Order_By,[dbo].[fBusca_Docs_PO_Modal](LEFT(FATURA_PC,16),19) Num_Proc_HBO
				FROM 
					FATURA_CHB FAT
					JOIN FATURA_CHB_ITEM ITM ON ITM.FATURA_CC=FAT.FATURA_PC
					JOIN PESSOA PP ON PP.CD_PES=CD_PES_PC
					LEFT Join Endereco ED on ED.cd_pes=cd_pes_PC and ED.cd_tp_end='COM'
					LEFT JOIN HOUSE_EXP_MAR HOU ON HOU.NUM_PROC_HEM=LEFT(FATURA_PC,16)
					LEFT JOIN cta_cte_hou_exp_mar CCH on CCH.num_proc_hem = LEFT(FATURA_PC,16) and CCH.num_nf_hem is not null AND CCH.REF_ACESSO_NF_Hem <> 'P' AND CCH.REF_ACESSO_NF_Hem is not null
					join Tipo_Taxa TT on TT.cd_tp_Tx=itm.cd_tp_Tx
					LEft Join PO_HEM PO on lefT(fat.fatura_pc,16)=po.num_proC_HEM AND ID_DC = 1
					Left Join Localidade Org on Org.cd_local=cd_org_HEM
					Left Join Localidade dst on dst.cd_local=cd_dst_HEM
					left join Pessoa CNS on CNS.cd_pes = HOU.cd_export_HEM
					Left Join Campo_Processo CP on CP.Num_Proc=left(@Fatura_PC,16) and Id_Campo=25
					Left Join Localidade LDE on LDE.cd_local=CP.Campo_Dados
					Left Join Fatura on fatcod=fatura_pc
					Left Join Tipo_Taxa_PC_CHB TCHB on TCHB.cd_tp_tx=TT.cd_tp_tx and cd_pes_grupo=@cd_pes
				WHERE 
					FATURA_PC=@FATURA_PC
				group by 
					HOU.Num_Proc_HEM,Data_PC,fatdtvenc,OBS_PC,Obs_Hem,right(pp.Num_CPF_CNPJ,14), Fatura_PC,pp.Apelido,pp.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,hawb_HEM ,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, CNS.Nome_Raz_Soc, LDE.Nome_Local,Ordem
				Order by order_by
			END

		IF left(@fatura_pc,2)='EA' and len(@fatura_pc)=17
			BEGIN
			insert @table
				SELECT 
					Data_PC,fatdtvenc,obs_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ, Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,RUA,Numero,Cidade,UF,max(Numero_PO_HEA) Referencia_Cliente,DI_RE_PC,org.nome_local Origem, dst.nome_local Destino,hawb_HEA House,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, Obs_hea OBS_HOU, CNS.Nome_Raz_Soc CNS, LDE.Nome_Local Local_Desemb,
					dbo.fBusca_Tarefa(HOU.Num_Proc_HEA,4) Dt_Desembaraco,fatDtVenc Vencimento,CCH.num_nf_hea num_nf,isnull(Ordem,99) Order_By,[dbo].[fBusca_Docs_PO_Modal](LEFT(FATURA_PC,16),19) Num_Proc_HBO
				FROM
					FATURA_CHB FAT
					JOIN FATURA_CHB_ITEM ITM ON ITM.FATURA_CC=FAT.FATURA_PC
					JOIN PESSOA PP ON PP.CD_PES=CD_PES_PC
					LEFT Join Endereco ED on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
					LEFT JOIN HOUSE_EXP_aer HOU ON HOU.NUM_PROC_HEA=LEFT(FATURA_PC,16)
					LEFT JOIN cta_cte_hou_exp_aer CCH on CCH.num_proc_hea = LEFT(FATURA_PC,16) and CCH.num_nf_hea is not null AND CCH.REF_ACESSO_NF_Hea <> 'P' AND CCH.REF_ACESSO_NF_Hea is not null
					join Tipo_Taxa TT on TT.cd_tp_Tx=itm.cd_tp_Tx
					LEft Join PO_HEA PO on lefT(fat.fatura_pc,16)=po.num_proC_HEA AND ID_DC = 1
					Left Join Localidade Org on Org.cd_local=cd_org_HEA
					Left Join Localidade dst on dst.cd_local=cd_dst_HEA
					left join Pessoa CNS on CNS.cd_pes = HOU.cd_export_HEA
					Left Join Campo_Processo CP on CP.Num_Proc=left(@Fatura_PC,16) and Id_Campo=25
					Left Join Localidade LDE on LDE.cd_local=CP.Campo_Dados
					Left Join Fatura on fatcod=fatura_pc
					Left Join Tipo_Taxa_PC_CHB TCHB on TCHB.cd_tp_tx=TT.cd_tp_tx and cd_pes_grupo=@cd_pes
				WHERE 
					FATURA_PC=@FATURA_PC
				group by 
					HOU.Num_Proc_HEA,Data_PC,fatdtvenc,obs_PC,obs_hea,right(pp.Num_CPF_CNPJ,14), Fatura_PC,pp.Apelido,pp.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,hawb_HEA ,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, CNS.Nome_Raz_Soc, LDE.Nome_Local,CCH.num_nf_hea ,Ordem
				Order by order_by
			END
			
		IF left(@fatura_pc,2)='EO' and len(@fatura_pc)=17
			BEGIN
			insert @table
				SELECT 
					Data_PC,fatdtvenc,obs_pc OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ, Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,RUA,Numero,Cidade,UF,max(Numero_PO_HEO) Referencia_Cliente,DI_RE_PC,org.nome_local Origem, dst.nome_local Destino,hawb_HEO House,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, Obs_heo OBS_HOU, CNS.Nome_raz_soc CNS, LDE.Nome_Local Local_Desemb,
					dbo.fBusca_Tarefa(HOU.Num_Proc_HEO,4) Dt_Desembaraco, fatDtVenc Vencimento, CCH.num_nf_heo num_nf,isnull(Ordem,99) Order_By,[dbo].[fBusca_Docs_PO_Modal](LEFT(FATURA_PC,16),19) Num_Proc_HBO
				FROM 
					FATURA_CHB FAT
					JOIN FATURA_CHB_ITEM ITM ON ITM.FATURA_CC=FAT.FATURA_PC
					JOIN PESSOA PP ON PP.CD_PES=CD_PES_PC
					LEFT Join Endereco ED on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
					LEFT JOIN HOUSE_EXP_out HOU ON HOU.NUM_PROC_HEO=LEFT(FATURA_PC,16)
					LEFT JOIN cta_cte_hou_exp_out CCH on CCH.num_proc_heo = LEFT(FATURA_PC,16) and CCH.num_nf_heo is not null AND CCH.REF_ACESSO_NF_Heo <> 'P' AND CCH.REF_ACESSO_NF_Heo is not null
					join Tipo_Taxa TT on TT.cd_tp_Tx=itm.cd_tp_Tx
					LEft Join PO_HEO PO on lefT(fat.fatura_pc,16)=po.num_proC_HEO AND ID_DC = 1
					Left Join Localidade Org on Org.cd_local=cd_org_HEO
					Left Join Localidade dst on dst.cd_local=cd_dst_HEO
					left join Pessoa CNS on CNS.cd_pes = HOU.cd_export_HEO
					Left Join Campo_Processo CP on CP.Num_Proc=left(@Fatura_PC,16) and Id_Campo=25
					Left Join Localidade LDE on LDE.cd_local=CP.Campo_Dados
					Left Join Fatura on fatcod=fatura_pc
					Left Join Tipo_Taxa_PC_CHB TCHB on TCHB.cd_tp_tx=TT.cd_tp_tx and cd_pes_grupo=@cd_pes
				WHERE 
					FATURA_PC=@FATURA_PC 
				group by 
					HOU.Num_Proc_HEO,Data_PC,fatdtvenc,obs_pc,obs_heo,right(pp.Num_CPF_CNPJ,14), Fatura_PC,pp.Apelido,pp.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,hawb_HEO ,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, CNS.Nome_raz_Soc, LDE.Nome_Local,num_nf_heo,Ordem
				Order by order_by
			END

		If left(@fatura_pc,2)='IO' and (len(@Fatura_PC) = 17 or len(@fatura_pc)=16)
			BEGIN
			insert @table
				SELECT 
					Data_PC,fatdtvenc,obs_pc OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ, Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,RUA,Numero,Cidade,UF,max(Numero_PO_HIO) Referencia_Cliente,DI_RE_PC,org.nome_local Origem, dst.nome_local Destino,hawb_HIO House,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, Obs_hio OBS_HOU, CNS.Nome_Raz_soc CNS, LDE.Nome_Local Local_Desemb,
					dbo.fBusca_Tarefa(HOU.Num_Proc_HIO,4) Dt_Desembaraco, fatDtVenc Vencimento, CCH.num_nf_hio num_nf,isnull(Ordem,99) Order_By,[dbo].[fBusca_Docs_PO_Modal](LEFT(FATURA_PC,16),19) Num_Proc_HBO
				FROM 
					FATURA_CHB FAT
					JOIN FATURA_CHB_ITEM ITM ON ITM.FATURA_CC=FAT.FATURA_PC
					JOIN PESSOA PP ON PP.CD_PES=CD_PES_PC
					LEFT Join Endereco ED on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
					LEFT JOIN HOUSE_IMP_out HOU ON HOU.NUM_PROC_HIO=LEFT(FATURA_PC,16)
					LEFT JOIN cta_cte_hou_imp_out CCH on CCH.num_proc_hio = LEFT(FATURA_PC,16) and CCH.num_nf_hio is not null AND CCH.REF_ACESSO_NF_Hio <> 'P' AND CCH.REF_ACESSO_NF_Hio is not null
					join Tipo_Taxa TT on TT.cd_tp_Tx=itm.cd_tp_Tx
					LEft Join PO_HIO PO on lefT(fat.fatura_pc,16)=po.num_proC_HIO AND ID_DC = 1
					Left Join Localidade Org on Org.cd_local=cd_org_HIO
					Left Join Localidade dst on dst.cd_local=cd_dst_HIO
					left join Pessoa CNS on CNS.cd_pes = HOU.cd_consig_HIO
					Left Join Campo_Processo CP on CP.Num_Proc=left(@Fatura_PC,16) and Id_Campo=25
					Left Join Localidade LDE on LDE.cd_local=CP.Campo_Dados
					Left Join Fatura on fatcod=fatura_pc
					Left Join Tipo_Taxa_PC_CHB TCHB on TCHB.cd_tp_tx=TT.cd_tp_tx and cd_pes_grupo=@cd_pes
				WHERE 
					FATURA_PC=@FATURA_PC 
				group by 
					HOU.Num_Proc_HIO,Data_PC,fatdtvenc,obs_pc,obs_hio,right(pp.Num_CPF_CNPJ,14), Fatura_PC,pp.Apelido,pp.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,hawb_HIO ,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, CNS.Nome_raz_Soc, LDE.Nome_Local,CCH.num_nf_hio,Ordem
				Order by order_by
			END
		IF left(@fatura_pc,2)='EA' and len(@fatura_pc)=15
			BEGIN
			insert @table
				SELECT 
					Data_PC,fatdtvenc,obs_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ, Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,RUA,Numero,Cidade,UF,max(Numero_PO) Referencia_Cliente,DI_RE_PC,org.nome_local Origem, dst.nome_local Destino,Mawb_mea House,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, Obs_mea OBS_HOU, CNS.Nome_Raz_Soc CNS, LDE.Nome_Local Local_Desemb,
					dbo.fBusca_Tarefa(MAS.Num_Proc_MEA,4) Dt_Desembaraco, fatDtVenc Vencimento,
--					max(CCM.NUM_NF_MEA) num_nf
					(select max(num_nf_mea) from cta_cte_mas_exp_aer where num_proc_mea = LEFT(FATURA_PC,14)) num_nf,isnull(Ordem,99) Order_By,[dbo].[fBusca_Docs_PO_Modal](LEFT(FATURA_PC,16),19) Num_Proc_HBO
				FROM 
					FATURA_CHB FAT
					JOIN FATURA_CHB_ITEM ITM ON ITM.FATURA_CC=FAT.FATURA_PC
					JOIN PESSOA PP ON PP.CD_PES=CD_PES_PC
					LEFT Join Endereco ED on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
					LEFT JOIN MASTER_EXP_aer MAS ON MAS.NUM_PROC_mea=LEFT(FATURA_PC,14)
					LEFT join cta_cte_mas_exp_aer CCM on CCM.num_proc_mEA = LEFT(FATURA_PC,14) and CCM.NUM_NF_MEA IS NOT NULL AND CCM.REF_ACESSO_NF_MEA <> 'P' AND CCM.REF_ACESSO_NF_MEA is not null
					join Tipo_Taxa TT on TT.cd_tp_Tx=itm.cd_tp_Tx
					LEft Join PO_Master PO on lefT(fat.fatura_pc,14)=po.num_proC_master AND ID_DC = 1
					Left Join Localidade Org on Org.cd_local=cd_org_mea
					Left Join Localidade dst on dst.cd_local=cd_dst_mea
					left join Pessoa CNS on CNS.cd_pes = MAS.cd_export_mea
					Left Join Campo_Processo CP on CP.Num_Proc=left(@Fatura_PC,14) and Id_Campo=25
					Left Join Localidade LDE on LDE.cd_local=CP.Campo_Dados
					Left Join Fatura on fatcod=fatura_pc
					Left Join Tipo_Taxa_PC_CHB TCHB on TCHB.cd_tp_tx=TT.cd_tp_tx and cd_pes_grupo=@cd_pes
				WHERE 
					FATURA_PC=@FATURA_PC 
				group by 
					MAS.Num_Proc_MEA,Data_PC,fatdtvenc,obs_PC,obs_mea,right(pp.Num_CPF_CNPJ,14), Fatura_PC,pp.Apelido,pp.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,Mawb_mea ,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, CNS.Nome_Raz_Soc, LDE.Nome_Local,CCM.NUM_NF_MEA,Ordem
				Order by order_by
			END
		IF left(@fatura_pc,2)='EM' and len(@fatura_pc)=15
			BEGIN
			insert @table
				SELECT 
					Data_PC,fatdtvenc,obs_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ, Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,RUA,Numero,Cidade,UF,max(Numero_PO) Referencia_Cliente,DI_RE_PC,org.nome_local Origem, dst.nome_local Destino,Mawb_mem House,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, Obs_mem OBS_HOU, CNS.Nome_Raz_Soc CNS, LDE.Nome_Local Local_Desemb,
					dbo.fBusca_Tarefa(MAS.Num_Proc_MEM,4) Dt_Desembaraco, fatDtVenc Vencimento, 
--					max(CCM.NUM_NF_MEM) num_nf
					(select max(num_nf_mem) from cta_cte_mas_exp_mar where num_proc_mem = LEFT(FATURA_PC,14)) num_nf,isnull(Ordem,99) Order_By,[dbo].[fBusca_Docs_PO_Modal](LEFT(FATURA_PC,16),19) Num_Proc_HBO
				FROM
					FATURA_CHB FAT
					JOIN FATURA_CHB_ITEM ITM ON ITM.FATURA_CC=FAT.FATURA_PC
					JOIN PESSOA PP ON PP.CD_PES=CD_PES_PC
					LEFT Join Endereco ED on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
					LEFT JOIN MASTER_EXP_mar MAS ON MAS.NUM_PROC_mem=LEFT(FATURA_PC,14)
					LEFT join cta_cte_mas_exp_mar CCM on CCM.num_proc_mEM = LEFT(FATURA_PC,14) and CCM.NUM_NF_MEM IS NOT NULL AND CCM.REF_ACESSO_NF_MEM <> 'P' AND CCM.REF_ACESSO_NF_MEM is not null
					join Tipo_Taxa TT on TT.cd_tp_Tx=itm.cd_tp_Tx
					LEft Join PO_Master PO on lefT(fat.fatura_pc,14)=po.num_proC_master AND ID_DC = 1
					Left Join Localidade Org on Org.cd_local=cd_org_mem
					Left Join Localidade dst on dst.cd_local=cd_dst_mem
					left join Pessoa CNS on CNS.cd_pes = MAS.cd_export_mem
					Left Join Campo_Processo CP on CP.Num_Proc=left(@Fatura_PC,14) and Id_Campo=25
					Left Join Localidade LDE on LDE.cd_local=CP.Campo_Dados
					Left Join Fatura on fatcod=fatura_pc
					Left Join Tipo_Taxa_PC_CHB TCHB on TCHB.cd_tp_tx=TT.cd_tp_tx and cd_pes_grupo=@cd_pes
				WHERE 
					FATURA_PC=@FATURA_PC 
				group by 
					MAS.Num_Proc_MEM,Data_PC,fatdtvenc,obs_PC,obs_mem,right(pp.Num_CPF_CNPJ,14), Fatura_PC,pp.Apelido,pp.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,Mawb_mem ,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, CNS.Nome_Raz_Soc, LDE.Nome_Local,CCM.NUM_NF_MEM,Ordem
				Order by order_by
			END
		IF left(@fatura_pc,2)='IM' and len(@fatura_pc)=15
			BEGIN
			insert @table
				SELECT 
					Data_PC,fatdtvenc,obs_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ, Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,RUA,Numero,Cidade,UF,max(Numero_PO) Referencia_Cliente,DI_RE_PC,org.nome_local Origem, dst.nome_local Destino,Mawb_mim House,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, Obs_mim OBS_HOU, CNS.Nome_Raz_Soc CNS, LDE.Nome_Local Local_Desemb,
					dbo.fBusca_Tarefa(MAS.Num_Proc_MIM,4) Dt_Desembaraco, fatDtVenc Vencimento,
--					max(CCM.NUM_NF_MIM) num_nf
					(select max(num_nf_mim) from cta_cte_mas_imp_mar where num_proc_mim = LEFT(FATURA_PC,14)) num_nf,isnull(Ordem,99) Order_By,[dbo].[fBusca_Docs_PO_Modal](LEFT(FATURA_PC,16),19) Num_Proc_HBO
				FROM
					FATURA_CHB FAT
					JOIN FATURA_CHB_ITEM ITM ON ITM.FATURA_CC=FAT.FATURA_PC
					JOIN PESSOA PP ON PP.CD_PES=CD_PES_PC
					LEFT Join Endereco ED on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
					LEFT JOIN MASTER_imp_mar MAS ON MAS.NUM_PROC_mim=LEFT(FATURA_PC,14)
					LEFT JOIN CTA_CTE_MAS_IMP_MAR CCM ON CCM.NUM_PROC_MIM = LEFT(FATURA_PC,14) AND CCM.NUM_NF_MIM IS NOT NULL AND CCM.REF_ACESSO_NF_MIM <> 'P' AND CCM.REF_ACESSO_NF_MIM is not null
					join Tipo_Taxa TT on TT.cd_tp_Tx=itm.cd_tp_Tx
					LEft Join PO_Master PO on lefT(fat.fatura_pc,14)=po.num_proC_master AND ID_DC = 1
					Left Join Localidade Org on Org.cd_local=cd_org_mim
					Left Join Localidade dst on dst.cd_local=cd_dst_mim
					left join Pessoa CNS on CNS.cd_pes = MAS.cd_consig_mim
					Left Join Campo_Processo CP on CP.Num_Proc=left(@Fatura_PC,14) and Id_Campo=25
					Left Join Localidade LDE on LDE.cd_local=CP.Campo_Dados
					Left Join Fatura on fatcod=fatura_pc
					Left Join Tipo_Taxa_PC_CHB TCHB on TCHB.cd_tp_tx=TT.cd_tp_tx and cd_pes_grupo=@cd_pes
				WHERE 
					FATURA_PC=@FATURA_PC 
				group by 
					MAS.Num_Proc_MIM,Data_PC,fatdtvenc,obs_PC,obs_mim,right(pp.Num_CPF_CNPJ,14), Fatura_PC,pp.Apelido,pp.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,Mawb_mim ,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, CNS.Nome_Raz_Soc, LDE.Nome_Local,CCM.NUM_NF_MIM,Ordem
				Order by order_by
			END
		IF left(@fatura_pc,2)='IA' and len(@fatura_pc)=15
			BEGIN
			insert @table
				SELECT 
					Data_PC,fatdtvenc,obs_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ, Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,RUA,Numero,Cidade,UF,max(Numero_PO) Referencia_Cliente,DI_RE_PC,org.nome_local Origem, dst.nome_local Destino,Mawb_mia House,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, Obs_mia OBS_HOU, CNS.Nome_Raz_Soc CNS, LDE.Nome_Local Local_Desemb,
					dbo.fBusca_Tarefa(MAS.Num_Proc_MIA,4) Dt_Desembaraco, fatDtVenc Vencimento, 
--					max(CCM.NUM_NF_MIA) num_nf
					(select max(num_nf_mia) from cta_cte_mas_imp_aer where num_proc_mia = LEFT(FATURA_PC,14)) num_nf,isnull(Ordem,99) Order_By,[dbo].[fBusca_Docs_PO_Modal](LEFT(FATURA_PC,16),19) Num_Proc_HBO
				FROM 
					FATURA_CHB FAT
					JOIN FATURA_CHB_ITEM ITM ON ITM.FATURA_CC=FAT.FATURA_PC
					JOIN PESSOA PP ON PP.CD_PES=CD_PES_PC
					LEFT Join Endereco ED on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
					LEFT JOIN MASTER_imp_aer MAS ON MAS.NUM_PROC_mia=LEFT(FATURA_PC,14)
					LEFT join cta_cte_mas_imp_AER CCM on CCM.num_proc_mIA = LEFT(FATURA_PC,14) and CCM.NUM_NF_MIA IS NOT NULL AND CCM.REF_ACESSO_NF_MIA <> 'P' AND CCM.REF_ACESSO_NF_MIA is not null
					join Tipo_Taxa TT on TT.cd_tp_Tx=itm.cd_tp_Tx
					LEft Join PO_Master PO on lefT(fat.fatura_pc,14)=po.num_proC_master AND ID_DC = 1
					Left Join Localidade Org on Org.cd_local=cd_org_mia
					Left Join Localidade dst on dst.cd_local=cd_dst_mia
					left join Pessoa CNS on CNS.cd_pes = MAS.cd_export_mia
					Left Join Campo_Processo CP on CP.Num_Proc=left(@Fatura_PC,14) and Id_Campo=25
					Left Join Localidade LDE on LDE.cd_local=CP.Campo_Dados
					Left Join Fatura on fatcod=fatura_pc
					Left Join Tipo_Taxa_PC_CHB TCHB on TCHB.cd_tp_tx=TT.cd_tp_tx and cd_pes_grupo=@cd_pes
				WHERE 
					FATURA_PC=@FATURA_PC 
				group by 
					MAS.Num_Proc_MIA,Data_PC,fatdtvenc,obs_PC,obs_mia,right(pp.Num_CPF_CNPJ,14), Fatura_PC,pp.Apelido,pp.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,Mawb_mia ,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, CNS.Nome_Raz_Soc, LDE.Nome_Local,CCM.NUM_NF_MIA,Ordem
				Order by order_by
			END

	END
		update  @Table set nome_tp_Tx='(-) IRRF 1.5%',order_by=999
		where nome_Tp_Tx like 'IRRF%'
		
		Update @table set nome_tp_Tx='(-) PIS/COFINS/CSLL 4.65%',order_by=999
		where nome_tp_tx like 'PIS%' and left(Cd_tp_Tx,1) <> 'X'
		
		Update @table set nome_tp_Tx='(-) PIS/COFINS/CSLL 4.65%',order_by=999
		where nome_tp_tx like 'Cofins%' and left(Cd_tp_Tx,1) <> 'X'
		
		Update @table set nome_tp_Tx='(-) PIS/COFINS/CSLL 4.65%',order_by=999
		where nome_tp_tx like 'CSLL%' and left(Cd_tp_Tx,1) <> 'X'
		
		Select 	
			Data_PC	,fatdtvenc ,OBS,Num_CPF_CNPJ ,	Fatura_PC,
			Apelido,Nome_raz_Soc,Rua,Numero,Cidade,
			UF,Referencia_Cliente,DI_RE_PC,Origem,Destino,
			House,max(cd_tp_Tx) CD_Tp_TX,Nome_Tp_TX,Sum(Vlr_PC) Vlr_PC,TP_PGTO,Obs_HOU,
			CNS,Local_Desemb,Dt_Desembaraco,Vencimento,
			Num_Nf,Order_by,Num_Proc_HBO
		From
			@Table
		Group by
			Data_PC	,fatdtvenc ,OBS,Num_CPF_CNPJ ,	Fatura_PC,
			Apelido,Nome_raz_Soc,Rua,Numero,Cidade,
			UF,Referencia_Cliente,DI_RE_PC,Origem,Destino,
			House,Nome_Tp_TX,TP_PGTO,Obs_HOU,
			CNS,Local_Desemb,Dt_Desembaraco,Vencimento,
			Num_Nf,Order_by,Num_Proc_HBO
		
		Order by Order_By



--select * from FATURA_CHB  where FATURA_PC like '%ocv%'
--
--IMOWE201205003BRA
--IMOVC201207001BRA

/*
	Criado para a OWENS, pra ter sequencia qdo aparece as taxas
	2. Prestação de Contas
	No documento deverão constar:
	2.1 Despesas na Seguinte Ordem /Sequencia:
	A. PIS
	B. COFINS
	C. ICMS
	D. IPI
	E. Imposto de Importação
	F. Serviços de Despachante 
	G. Todas as Despesas que houverem ( BL, THC, Transporte, Armazenagem, ......etc)

--22-12-2016 - BO
ALTER Procedure [dbo].[spPrestCC_REL_OVC]--[dbo].[spPrestCC_REL_OVC] 'IAOCV201208001BRA','S'
		@Fatura_PC varchar(17),
		@Tipo	Varchar(1)

as

	Declare @Table Table
		(
			Data_PC	Datetime,
			fatDtVenc Datetime,
			OBS		Varchar(500),
			Num_CPF_CNPJ varchar(20),
			Fatura_PC	Varchar(17),
			Apelido		Varchar(50),
			Nome_Raz_Soc	varchar(50),
			RUA				Varchar(150),
			Numero			Varchar(50),
			Cidade			Varchar(50),
			UF				Char(2),
			Referencia_Cliente	Varchar(150),
			DI_RE_PC			Varchar(50),
			Origem				Varchar(50),
			Destino				Varchar(50),
			House				Varchar(50),
			CD_TP_TX			varchar(3),
			NOME_TP_TX			varchar(500),
			VLR_PC				Decimal(10,2),
			TP_PGTO				Char(1),
			OBS_HOU				Varchar(500),
			CNS					Varchar(100),
			Local_Desemb		Varchar(100),
			Dt_Desembaraco		Datetime,
			Vencimento			Datetime,
			num_nf				Varchar(100),
			Order_By			int
			)
	--select * from @table
	Declare @Cd_Pes Varchar(10)
	
--	Set @CD_PES=(select cd_pes_Grupo from grupo where grupo=substring('IMOCV201205001BRA',3,3))

	Set @CD_PES='P000007153'

IF @TIPO='S'
	BEGIN
	
		if left(@fatura_pc,2)='BO' and (len(@Fatura_PC) = 17 or len(@fatura_pc)=16)
			BEGIN
				insert @table
					SELECT 
						Distinct
						Data_PC,
						fatDtVenc,
						Obs_PC OBS,
						right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ,
						Fatura_PC,
						PP.Apelido,
						PP.Nome_Raz_Soc,
						RUA,
						Numero,
						Cidade,
						UF,
						max(Numero_PO_HBO) Referencia_Cliente,
						DI_RE_PC,
						'' Origem,
						'' Destino,
						'' House,
						ITM.CD_TP_TX,
						NOME_TP_TX,
						VLR_PC,
						TP_PGTO,
						'' OBS_HOU,
						CNS.Nome_Raz_Soc CNS,
						LDE.Nome_Local Local_Desemb,
						dbo.fBusca_Tarefa(HOU.Num_Proc_HBO,4) Dt_Desembaraco,
						fatDtVenc Vencimento,
						Max(CCH.Num_NF_HBO) num_nf,
						isnull(Ordem,99) Order_By
					FROM 
						FATURA_CHB FAT
						JOIN FATURA_CHB_ITEM ITM ON ITM.FATURA_CC=FAT.FATURA_PC
						JOIN PESSOA PP ON PP.CD_PES=CD_PES_PC 
						LEFT Join Endereco ED on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
						LEFT JOIN House_BDP_OUT HOU ON HOU.Num_Proc_HBO=LEFT(FATURA_PC,16)
						LEFT JOIN Cta_Cte_HOU_BDP_OUT CCH on CCH.num_proc_hbo = LEFT(FATURA_PC,16) and CCH.num_nf_hbo is not null AND CCH.Ref_Acesso_NF_HBO <> 'P' AND CCH.Ref_Acesso_NF_HBO is not null
						join Tipo_Taxa TT on TT.cd_tp_Tx=itm.cd_tp_Tx
						LEft Join PO_HBO PO on lefT(fat.fatura_pc,16)=po.Num_Proc_HBO AND ID_DC = 1
						--Join Localidade Org on Org.cd_local=cd_org_HEO
						--Join Localidade dst on dst.cd_local=cd_dst_HEO
						left join Pessoa CNS on CNS.cd_pes = HOU.cd_cliente_hbo
						Left Join Campo_Processo CP on CP.Num_Proc=left(@Fatura_PC,16) and Id_Campo=25
						Left Join Localidade LDE on LDE.cd_local=CP.Campo_Dados
						Left Join Fatura on fatcod=fatura_pc
						Left Join Tipo_Taxa_PC_CHB TCHB on TCHB.cd_tp_tx=TT.cd_tp_tx and cd_pes_grupo=@cd_pes
					WHERE 
						FATURA_PC=@FATURA_PC and imprime='S'
					group by 
						HOU.Num_Proc_HBO, Data_pc,fatdtvenc,Obs_Pc,
						--Obs_HBo,
						right(PP.Num_CPF_CNPJ,14),Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,
						--org.nome_local , dst.nome_local ,hawb_HEO ,
						ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, CNS.Nome_Raz_Soc, LDE.Nome_Local,Ordem
					Order by order_by
			END

	    if left(@fatura_pc,2)='EO' and (len(@Fatura_PC) = 17 or len(@fatura_pc)=16)
		BEGIN
			insert @table
			SELECT 
				Distinct
				Data_PC,
				fatDtVenc,
				Obs_PC OBS,
				right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ,
				Fatura_PC,
				PP.Apelido,
				PP.Nome_Raz_Soc,
				RUA,
				Numero,
				Cidade,
				UF,
				max(Numero_PO_HEO) Referencia_Cliente,
				DI_RE_PC,
				org.nome_local Origem,
				dst.nome_local Destino,
				hawb_HEO House,
				ITM.CD_TP_TX,
				NOME_TP_TX,
				VLR_PC,
				TP_PGTO,
				Obs_heo OBS_HOU,
				CNS.Nome_Raz_Soc CNS,
				LDE.Nome_Local Local_Desemb,
				dbo.fBusca_Tarefa(HOU.Num_Proc_HEO,4) Dt_Desembaraco,
				fatDtVenc Vencimento,
				Max(CCH.num_nf_heo) num_nf,
				isnull(Ordem,99) Order_By
			FROM 
				FATURA_CHB FAT
				JOIN FATURA_CHB_ITEM ITM ON ITM.FATURA_CC=FAT.FATURA_PC
				JOIN PESSOA PP ON PP.CD_PES=CD_PES_PC 
				LEFT Join Endereco ED on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
				LEFT JOIN HOUSE_EXP_OUT HOU ON HOU.NUM_PROC_HEO=LEFT(FATURA_PC,16)
				LEFT JOIN cta_cte_hou_exp_out CCH on CCH.num_proc_heo = LEFT(FATURA_PC,16) and CCH.num_nf_heo is not null AND CCH.REF_ACESSO_NF_Heo <> 'P' AND CCH.REF_ACESSO_NF_Heo is not null
				join Tipo_Taxa TT on TT.cd_tp_Tx=itm.cd_tp_Tx
				LEft Join PO_HEO PO on lefT(fat.fatura_pc,16)=po.num_proC_HEO AND ID_DC = 1
				Join Localidade Org on Org.cd_local=cd_org_HEO
				Join Localidade dst on dst.cd_local=cd_dst_HEO
				left join Pessoa CNS on CNS.cd_pes = HOU.cd_export_HEO
				Left Join Campo_Processo CP on CP.Num_Proc=left(@Fatura_PC,16) and Id_Campo=25
				Left Join Localidade LDE on LDE.cd_local=CP.Campo_Dados
				Left Join Fatura on fatcod=fatura_pc
				Left Join Tipo_Taxa_PC_CHB TCHB on TCHB.cd_tp_tx=TT.cd_tp_tx and cd_pes_grupo=@cd_pes
			WHERE 
				FATURA_PC=@FATURA_PC and imprime='S'
			group by 
				HOU.Num_Proc_HEO, Data_pc,fatdtvenc,Obs_Pc,Obs_Heo,right(PP.Num_CPF_CNPJ,14),Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,hawb_HEO ,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, CNS.Nome_Raz_Soc, LDE.Nome_Local,Ordem
			Order by order_by
		END

	    if left(@fatura_pc,2)='IO' and (len(@Fatura_PC) = 17 or len(@fatura_pc)=16)
		BEGIN
		insert @table
			SELECT 
				Distinct
				Data_PC,fatdtvenc,Obs_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ ,Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,RUA,Numero,Cidade,UF,max(Numero_PO_HIO) Referencia_Cliente,DI_RE_PC,org.nome_local Origem, dst.nome_local Destino,hawb_HIO House,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO,Obs_hio OBS_HOU, CNS.Nome_Raz_Soc CNS, LDE.Nome_Local Local_Desemb,
				dbo.fBusca_Tarefa(HOU.Num_Proc_HIO,4) Dt_Desembaraco,fatDtVenc Vencimento, MAx(cch.num_nf_hio) num_nf,isnull(Ordem,99) Order_By
			FROM 
				FATURA_CHB FAT
				JOIN FATURA_CHB_ITEM ITM ON ITM.FATURA_CC=FAT.FATURA_PC
				JOIN PESSOA PP ON PP.CD_PES=CD_PES_PC 
				LEFT Join Endereco ED on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
				LEFT JOIN HOUSE_IMP_OUT HOU ON HOU.NUM_PROC_HIO=LEFT(FATURA_PC,16)
				LEFT JOIN cta_cte_hou_imp_out CCH on CCH.num_proc_hio = LEFT(FATURA_PC,16) and CCH.num_nf_hio is not null AND CCH.REF_ACESSO_NF_HIo <> 'P' AND CCH.REF_ACESSO_NF_Hio is not null
				join Tipo_Taxa TT on TT.cd_tp_Tx=itm.cd_tp_Tx
				LEft Join PO_HIO PO on lefT(fat.fatura_pc,16)=po.num_proC_HIO AND ID_DC = 1
				Join Localidade Org on Org.cd_local=cd_org_HIO
				Join Localidade dst on dst.cd_local=cd_dst_HIO
				left join Pessoa CNS on CNS.cd_pes = HOU.cd_consig_HIO
				Left Join Campo_Processo CP on CP.Num_Proc=left(@Fatura_PC,16) and Id_Campo=25
				Left Join Localidade LDE on LDE.cd_local=CP.Campo_Dados
				Left Join Fatura on fatcod=fatura_pc
				Left Join Tipo_Taxa_PC_CHB TCHB on TCHB.cd_tp_tx=TT.cd_tp_tx and cd_pes_grupo=@cd_pes
			WHERE 
				FATURA_PC=@FATURA_PC and imprime='S'
			group by 
				HOU.Num_Proc_HIO,Data_PC,fatdtvenc,Obs_PC,obs_hio,right(PP.Num_CPF_CNPJ,14),Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,hawb_HIO ,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, CNS.Nome_Raz_Soc, LDE.Nome_Local,Ordem
			Order by order_by
		END

	    if left(@fatura_pc,2)='IM' and (len(@Fatura_PC) = 17 or len(@Fatura_PC) = 16)
		BEGIN
			insert @table
			SELECT 
				Distinct
				Data_PC,fatdtvenc,OBS_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ ,Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,RUA,Numero,Cidade,UF,max(Numero_PO_HIM) Referencia_Cliente,DI_RE_PC,org.nome_local Origem, dst.nome_local Destino,hawb_him House,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, Obs_him OBS_HOU, CNS.Nome_Raz_Soc CNS, LDE.Nome_Local Local_Desemb,
				dbo.fBusca_Tarefa(HOU.Num_Proc_HIM,4) Dt_Desembaraco,fatDtVenc Vencimento,max(CCH.num_nf_him) num_nf,isnull(Ordem,99) Order_By
			FROM 
				FATURA_CHB FAT
				JOIN FATURA_CHB_ITEM ITM ON ITM.FATURA_CC=FAT.FATURA_PC
				JOIN PESSOA PP ON PP.CD_PES=CD_PES_PC
				LEFT Join Endereco ED on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
				LEFT JOIN HOUSE_IMP_MAR HOU ON HOU.NUM_PROC_HIM=LEFT(FATURA_PC,16)
				LEFT JOIN cta_cte_hou_imp_mar CCH on CCH.num_proc_him = LEFT(FATURA_PC,16) and CCH.num_nf_him is not null AND CCH.REF_ACESSO_NF_HIM <> 'P' AND CCH.REF_ACESSO_NF_Him is not null
				join Tipo_Taxa TT on TT.cd_tp_Tx=itm.cd_tp_Tx
				LEft Join PO_HIM PO on lefT(fat.fatura_pc,16)=po.num_proC_him AND ID_DC = 1
				Join Localidade Org on Org.cd_local=cd_org_him
				Join Localidade dst on dst.cd_local=cd_dst_him
				left join Pessoa CNS on CNS.cd_pes = HOU.cd_consig_HIM
				Left Join Campo_Processo CP on CP.Num_Proc=left(@Fatura_PC,16) and Id_Campo=25
				Left Join Localidade LDE on LDE.cd_local=CP.Campo_Dados
				Left Join Fatura on fatcod=fatura_pc
				Left Join Tipo_Taxa_PC_CHB TCHB on TCHB.cd_tp_tx=TT.cd_tp_tx and cd_pes_grupo=@cd_pes
			WHERE 
				FATURA_PC=@FATURA_PC and imprime='S'
			group by 
				HOU.Num_Proc_HIM,Data_PC,fatdtvenc,Obs_PC,obs_him,right(pp.Num_CPF_CNPJ,14),Fatura_PC,pp.Apelido,pp.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,hawb_him ,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, CNS.Nome_Raz_Soc, LDE.Nome_Local,Ordem
			Order by order_by
			END
		
		IF left(@fatura_pc,2)='IA' and (len(@Fatura_PC) = 17 or len(@fatura_pc)=16)
			BEGIN
				insert @table
				SELECT 
					Data_PC,fatdtvenc,Obs_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ, Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,RUA,Numero,Cidade,UF, max(Numero_PO_hia) Referencia_Cliente,DI_RE_PC,org.nome_local Origem, dst.nome_local Destino,hawb_hia House,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, Obs_hia OBS_HOU, CNS.Nome_Raz_Soc CNS, LDE.Nome_Local Local_Desemb,
					dbo.fBusca_Tarefa(HOU.Num_Proc_HIA,4) Dt_Desembaraco,fatDtVenc Vencimento, Max(cch.num_nf_hia) num_nf,isnull(Ordem,99) Order_By
				FROM 
					FATURA_CHB FAT
					JOIN FATURA_CHB_ITEM ITM ON ITM.FATURA_CC=FAT.FATURA_PC
					JOIN PESSOA PP ON PP.CD_PES=CD_PES_PC
					LEFT Join Endereco ED on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
					LEFT JOIN HOUSE_IMP_aer HOU ON HOU.NUM_PROC_hia=LEFT(FATURA_PC,16)
					LEFT JOIN cta_cte_hou_imp_aer CCH on CCH.num_proc_hia = LEFT(FATURA_PC,16) and CCH.num_nf_hia is not null AND CCH.REF_ACESSO_NF_HIa <> 'P' AND CCH.REF_ACESSO_NF_Hia is not null
					join Tipo_Taxa TT on TT.cd_tp_Tx=itm.cd_tp_Tx
					LEft Join PO_hia PO on lefT(fat.fatura_pc,16)=po.num_proC_hia  AND ID_DC = 1
					Join Localidade Org on Org.cd_local=cd_org_hia
					Join Localidade dst on dst.cd_local=cd_dst_hia
					left join Pessoa CNS on CNS.cd_pes = HOU.cd_consig_HIA
					Left Join Campo_Processo CP on CP.Num_Proc=left(@Fatura_PC,16) and Id_Campo=25
					Left Join Localidade LDE on LDE.cd_local=CP.Campo_Dados
					Left Join Fatura on fatcod=fatura_pc
					Left Join Tipo_Taxa_PC_CHB TCHB on TCHB.cd_tp_tx=TT.cd_tp_tx and cd_pes_grupo=@cd_pes
				WHERE 
					FATURA_PC=@FATURA_PC and imprime='S'
				group by 
					HOU.Num_Proc_HIA,Data_PC,fatdtvenc,obs_PC,obs_hia,right(pp.Num_CPF_CNPJ,14), Fatura_PC,pp.Apelido,pp.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,hawb_hia ,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, CNS.Nome_Raz_Soc, LDE.Nome_Local,Ordem
				Order by order_by
			END		
		IF left(@fatura_pc,2)='EM' and (len(@Fatura_PC) = 17 or len(@fatura_pc)=16)
			BEGIN
				insert @table
				SELECT 
					Data_PC,fatdtvenc,OBS_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ ,Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,RUA,Numero,Cidade,UF,max(Numero_PO_HEM) Referencia_Cliente,DI_RE_PC,org.nome_local Origem, dst.nome_local Destino,hawb_HEM House,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, Obs_hem OBS_HOU, CNS.Nome_Raz_Soc CNS, LDE.Nome_Local Local_Desemb,
					dbo.fBusca_Tarefa(HOU.Num_Proc_HEM,4) Dt_Desembaraco,fatDtVenc Vencimento, max(cch.num_nf_hem) num_nf,isnull(Ordem,99) Order_By
				FROM 
					FATURA_CHB FAT
					JOIN FATURA_CHB_ITEM ITM ON ITM.FATURA_CC=FAT.FATURA_PC
					JOIN PESSOA PP ON PP.CD_PES=CD_PES_PC
					LEFT Join Endereco ED on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
					LEFT JOIN HOUSE_EXP_MAR HOU ON HOU.NUM_PROC_HEM=LEFT(FATURA_PC,16)
					LEFT JOIN cta_cte_hou_exp_mar CCH on CCH.num_proc_hem = LEFT(FATURA_PC,16) 
					and CCH.num_nf_hem is not null AND CCH.REF_ACESSO_NF_HeM <> 'P'
					join Tipo_Taxa TT on TT.cd_tp_Tx=itm.cd_tp_Tx
					LEft Join PO_HEM PO on lefT(fat.fatura_pc,16)=po.num_proC_HEM AND ID_DC = 1
					Join Localidade Org on Org.cd_local=cd_org_HEM
					Join Localidade dst on dst.cd_local=cd_dst_HEM
					left join Pessoa CNS on CNS.cd_pes = HOU.cd_export_HEM
					Left Join Campo_Processo CP on CP.Num_Proc=left(@Fatura_PC,16) and Id_Campo=25
					Left Join Localidade LDE on LDE.cd_local=CP.Campo_Dados
					Left Join Fatura on fatcod=fatura_pc
					Left Join Tipo_Taxa_PC_CHB TCHB on TCHB.cd_tp_tx=TT.cd_tp_tx and cd_pes_grupo=@cd_pes
				WHERE 
					FATURA_PC=@FATURA_PC and IMPrime='S'
				group by 
					HOU.Num_Proc_HEM,Data_PC,fatdtvenc,OBS_PC,obs_hem,right(pp.Num_CPF_CNPJ,14),Fatura_PC,pp.Apelido,pp.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,hawb_HEM ,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, CNS.Nome_Raz_Soc, LDE.Nome_Local,Ordem
				Order by order_by
			END
		
		IF left(@fatura_pc,2)='EA' and (len(@Fatura_PC) = 17 or len(@fatura_pc)=16)
			BEGIN
			insert @table
				SELECT 
					Data_PC,fatdtvenc,obs_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ, Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,RUA,Numero,Cidade,UF,max(Numero_PO_HEA) Referencia_Cliente,DI_RE_PC,org.nome_local Origem, dst.nome_local Destino,hawb_HEA House,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, Obs_hea OBS_HOU, CNS.Nome_Raz_Soc CNS, LDE.Nome_Local Local_Desemb,
					dbo.fBusca_Tarefa(HOU.Num_Proc_HEA,4) Dt_Desembaraco,fatDtVenc Vencimento, Max(CCH.num_nf_hea) num_nf,isnull(Ordem,99) Order_By
				FROM 
					FATURA_CHB FAT
					JOIN FATURA_CHB_ITEM ITM ON ITM.FATURA_CC=FAT.FATURA_PC
					JOIN PESSOA PP ON PP.CD_PES=CD_PES_PC
					LEFT Join Endereco ED on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
					LEFT JOIN HOUSE_EXP_aer HOU ON HOU.NUM_PROC_HEA=LEFT(FATURA_PC,16)
					LEFT JOIN cta_cte_hou_exp_aer CCH on CCH.num_proc_hea = LEFT(FATURA_PC,16) and CCH.num_nf_hea is not null AND CCH.REF_ACESSO_NF_Hea <> 'P' AND CCH.REF_ACESSO_NF_Hea is not null
					join Tipo_Taxa TT on TT.cd_tp_Tx=itm.cd_tp_Tx
					LEft Join PO_HEA PO on lefT(fat.fatura_pc,16)=po.num_proC_HEA AND ID_DC = 1
					Join Localidade Org on Org.cd_local=cd_org_HEA
					Join  Localidade dst on dst.cd_local=cd_dst_HEA
					left join Pessoa CNS on CNS.cd_pes = HOU.cd_export_HEA
					Left Join Campo_Processo CP on CP.Num_Proc=left(@Fatura_PC,16) and Id_Campo=25
					Left Join Localidade LDE on LDE.cd_local=CP.Campo_Dados
					Left Join Fatura on fatcod=fatura_pc
					Left Join Tipo_Taxa_PC_CHB TCHB on TCHB.cd_tp_tx=TT.cd_tp_tx and cd_pes_grupo=@cd_pes
				where 
					FATURA_PC=@FATURA_PC and IMPrime='S'
				group by 
					HOU.Num_Proc_HEA,Data_PC,fatdtvenc,obs_PC,obs_hea,right(pp.Num_CPF_CNPJ,14), Fatura_PC,pp.Apelido,pp.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,hawb_HEA ,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, CNS.Nome_Raz_Soc, LDE.Nome_Local,Ordem
				Order by order_by
			END

		IF left(@fatura_pc,2)='EA' and (len(@Fatura_PC) = 15 or len(@fatura_pc)=14)
		
			BEGIN
			insert @table
				SELECT 
					Data_PC,fatdtvenc,obs_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ, Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,RUA,Numero,Cidade,UF,max(Numero_PO) Referencia_Cliente,DI_RE_PC,org.nome_local Origem, dst.nome_local Destino,Mawb_MEA HOUSE,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, Obs_MEA OBS_MAS, CNS.Nome_Raz_Soc CNS, LDE.Nome_Local Local_Desemb,
					dbo.fBusca_Tarefa(MAS.Num_Proc_MEA,4) Dt_Desembaraco,fatDtVenc Vencimento, 
					--MAx(CCM.NUM_NF_MeA)) num_nf
					(select max(num_nf_mea) from cta_cte_mas_exp_aer where num_proc_mea = LEFT(FATURA_PC,14)) num_nf,isnull(Ordem,99) Order_By
				FROM 
					FATURA_CHB FAT
					JOIN FATURA_CHB_ITEM ITM ON ITM.FATURA_CC=FAT.FATURA_PC
					JOIN PESSOA PP ON PP.CD_PES=CD_PES_PC
					LEFT Join Endereco ED on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
					LEFT JOIN MASTER_EXP_aer MAS ON MAS.NUM_PROC_MEA=LEFT(FATURA_PC,14)
					--LEFT join cta_cte_mas_exp_AER CCM on CCM.num_proc_meA = LEFT(FATURA_PC,14) and CCM.NUM_NF_MeA IS NOT NULL AND CCM.REF_ACESSO_NF_MeA <> 'P' AND CCM.REF_ACESSO_NF_MEA is not null
					join Tipo_Taxa TT on TT.cd_tp_Tx=itm.cd_tp_Tx
					LEft Join PO_Master PO on lefT(fat.fatura_pc,14)=po.num_proC_Master AND ID_DC = 1
					Join Localidade Org on Org.cd_local=cd_org_MEA
					Join  Localidade dst on dst.cd_local=cd_dst_MEA
					left join Pessoa CNS on CNS.cd_pes = MAS.cd_export_MEA
					Left Join Campo_Processo CP on CP.Num_Proc=left(@Fatura_PC,14) and Id_Campo=25
					Left Join Localidade LDE on LDE.cd_local=CP.Campo_Dados
					Left Join Fatura on fatcod=fatura_pc
					Left Join Tipo_Taxa_PC_CHB TCHB on TCHB.cd_tp_tx=TT.cd_tp_tx and cd_pes_grupo=@cd_pes
				where 
					FATURA_PC=@FATURA_PC and IMPrime='S'
				group by 
					MAS.Num_Proc_MEA,Data_PC,fatdtvenc,obs_PC,obs_MEA,right(pp.Num_CPF_CNPJ,14), Fatura_PC,pp.Apelido,pp.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,Mawb_MEA ,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, CNS.Nome_Raz_Soc, LDE.Nome_Local,Ordem
				Order by order_by
			END
		IF left(@fatura_pc,2)='EM' and (len(@Fatura_PC) = 15 or len(@fatura_pc)=14)
		
			BEGIN
			insert @table
				SELECT 
					Data_PC,fatdtvenc,obs_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ, Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,RUA,Numero,Cidade,UF,max(Numero_PO) Referencia_Cliente,DI_RE_PC,org.nome_local Origem, dst.nome_local Destino,Mawb_mem HOUSE,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, Obs_mem OBS_MAS, CNS.Nome_Raz_Soc CNS, LDE.Nome_Local Local_Desemb,
					dbo.fBusca_Tarefa(MAS.Num_Proc_MEM,4) Dt_Desembaraco,fatDtVenc Vencimento, 
					--Max(CCM.NUM_NF_Mem) num_nf
					(select max(num_nf_mem) from cta_cte_mas_exp_mar where num_proc_mem = LEFT(FATURA_PC,14)) num_nf,isnull(Ordem,99) Order_By
				FROM
					FATURA_CHB FAT
					JOIN FATURA_CHB_ITEM ITM ON ITM.FATURA_CC=FAT.FATURA_PC
					JOIN PESSOA PP ON PP.CD_PES=CD_PES_PC
					LEFT Join Endereco ED on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
					LEFT JOIN MASTER_EXP_mar MAS ON MAS.NUM_PROC_mem=LEFT(FATURA_PC,14)
					--LEFT join cta_cte_mas_exp_mar CCM on CCM.num_proc_mem = LEFT(FATURA_PC,14) and CCM.NUM_NF_MeM IS NOT NULL AND CCM.REF_ACESSO_NF_MeM <> 'P' AND CCM.REF_ACESSO_NF_MEM is not null
					join Tipo_Taxa TT on TT.cd_tp_Tx=itm.cd_tp_Tx
					LEft Join PO_Master PO on lefT(fat.fatura_pc,14)=po.num_proC_Master AND ID_DC = 1
					Join Localidade Org on Org.cd_local=cd_org_mem
					Join  Localidade dst on dst.cd_local=cd_dst_mem
					left join Pessoa CNS on CNS.cd_pes = MAS.cd_export_mem
					Left Join Campo_Processo CP on CP.Num_Proc=left(@Fatura_PC,14) and Id_Campo=25
					Left Join Localidade LDE on LDE.cd_local=CP.Campo_Dados
					Left Join Fatura on fatcod=fatura_pc
					Left Join Tipo_Taxa_PC_CHB TCHB on TCHB.cd_tp_tx=TT.cd_tp_tx and cd_pes_grupo=@cd_pes
				where 
					FATURA_PC=@FATURA_PC and IMPrime='S'
				group by 
					MAS.Num_Proc_MEM,Data_PC,fatdtvenc,obs_PC,obs_mem,right(pp.Num_CPF_CNPJ,14), Fatura_PC,pp.Apelido,pp.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,Mawb_mem ,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, CNS.Nome_Raz_Soc, LDE.Nome_Local,Ordem
				Order by order_by
			END
		IF left(@fatura_pc,2)='IM' and (len(@Fatura_PC) = 15 OR len(@Fatura_PC) = 14)
			BEGIN
			insert @table
				SELECT 
					Data_PC,fatdtvenc,obs_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ, Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,RUA,Numero,Cidade,UF,max(Numero_PO) Referencia_Cliente,DI_RE_PC,org.nome_local Origem, dst.nome_local Destino,Mawb_mim HOUSE,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, Obs_mim OBS_MAS, CNS.Nome_Raz_Soc CNS, LDE.Nome_Local Local_Desemb, 
					dbo.fBusca_Tarefa(MAS.Num_Proc_MIM,4) Dt_Desembaraco,fatDtVenc Vencimento,
					--max(CCM.NUM_NF_MIM) num_nf
					(select max(num_nf_mim) from cta_cte_mas_imp_mar where num_proc_mim = LEFT(FATURA_PC,14)) num_nf,isnull(Ordem,99) Order_By
				FROM 
					FATURA_CHB FAT
					JOIN FATURA_CHB_ITEM ITM ON ITM.FATURA_CC=FAT.FATURA_PC
					JOIN PESSOA PP ON PP.CD_PES=CD_PES_PC
					LEFT Join Endereco ED on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
					LEFT JOIN MASTER_imp_mar MAS ON MAS.NUM_PROC_mim=LEFT(FATURA_PC,14)
					--LEFT join cta_cte_mas_imp_mar CCM on CCM.num_proc_mim = LEFT(FATURA_PC,14) and CCM.NUM_NF_MIM IS NOT NULL AND CCM.REF_ACESSO_NF_MIM <> 'P' AND CCM.REF_ACESSO_NF_MIM is not null
					join Tipo_Taxa TT on TT.cd_tp_Tx=itm.cd_tp_Tx
					LEft Join PO_Master PO on lefT(fat.fatura_pc,14)=po.num_proC_Master AND ID_DC = 1
					Join Localidade Org on Org.cd_local=cd_org_mim
					Join  Localidade dst on dst.cd_local=cd_dst_mim
					left join Pessoa CNS on CNS.cd_pes = MAS.cd_consig_mim
					Left Join Campo_Processo CP on CP.Num_Proc=left(@Fatura_PC,14) and Id_Campo=25
					Left Join Localidade LDE on LDE.cd_local=CP.Campo_Dados
					Left Join Fatura on fatcod=fatura_pc
					Left Join Tipo_Taxa_PC_CHB TCHB on TCHB.cd_tp_tx=TT.cd_tp_tx and cd_pes_grupo=@cd_pes
				where 
					FATURA_PC=@FATURA_PC and IMPrime='S'
				group by 
					MAS.Num_Proc_MIM,Data_PC,fatdtvenc,obs_PC,obs_mim,right(pp.Num_CPF_CNPJ,14), Fatura_PC,pp.Apelido,pp.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,Mawb_mim ,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, CNS.Nome_Raz_Soc, LDE.Nome_Local,Ordem--,NUM_NF_MIM
				Order by order_by
			END
		IF left(@fatura_pc,2)='IA' and (len(@Fatura_PC) = 15 or len(@fatura_pc)=14)

			BEGIN
			insert @table
				SELECT 
					Data_PC,fatdtvenc,obs_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ, Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,RUA,Numero,Cidade,UF,max(Numero_PO) Referencia_Cliente,DI_RE_PC,org.nome_local Origem, dst.nome_local Destino,Mawb_mia HOUSE,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, Obs_mia OBS_MAS, CNS.Nome_Raz_Soc CNS, LDE.Nome_Local Local_Desemb,
					dbo.fBusca_Tarefa(MAS.Num_Proc_MIA,4) Dt_Desembaraco ,fatDtVenc Vencimento,
--					max(CCM.NUM_NF_MIA) num_nf
					(select max(num_nf_mia) from cta_cte_mas_imp_aer where num_proc_mia = LEFT(FATURA_PC,14)) num_nf,isnull(Ordem,99) Order_By
				FROM 
					FATURA_CHB FAT
					JOIN FATURA_CHB_ITEM ITM ON ITM.FATURA_CC=FAT.FATURA_PC
					JOIN PESSOA PP ON PP.CD_PES=CD_PES_PC
					LEFT Join Endereco ED on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
					LEFT JOIN MASTER_imp_aer MAS ON MAS.NUM_PROC_mia=LEFT(FATURA_PC,14)
					--LEFT join cta_cte_mas_imp_AER CCM on CCM.num_proc_miA = LEFT(FATURA_PC,14) and CCM.NUM_NF_MIA IS NOT NULL AND CCM.REF_ACESSO_NF_MIA <> 'P' AND CCM.REF_ACESSO_NF_MIA is not null
					join Tipo_Taxa TT on TT.cd_tp_Tx=itm.cd_tp_Tx
					LEft Join PO_Master PO on lefT(fat.fatura_pc,14)=po.num_proC_Master AND ID_DC = 1
					Join Localidade Org on Org.cd_local=cd_org_mia
					Join  Localidade dst on dst.cd_local=cd_dst_mia
					left join Pessoa CNS on CNS.cd_pes = MAS.cd_consig_mia
					Left Join Campo_Processo CP on CP.Num_Proc=left(@Fatura_PC,14) and Id_Campo=25
					Left Join Localidade LDE on LDE.cd_local=CP.Campo_Dados
					Left Join Fatura on fatcod=fatura_pc
					Left Join Tipo_Taxa_PC_CHB TCHB on TCHB.cd_tp_tx=TT.cd_tp_tx and cd_pes_grupo=@cd_pes
				where 
					FATURA_PC=@FATURA_PC and IMPrime='S'
				group by 
					MAS.Num_Proc_MIA,Data_PC,fatdtvenc,obs_PC,obs_mia,right(pp.Num_CPF_CNPJ,14), Fatura_PC,pp.Apelido,pp.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,Mawb_mia ,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, CNS.Nome_Raz_Soc, LDE.Nome_Local,Ordem--NUM_NF_MIA
				Order by order_by
			END		
		end
ELSE
IF @TIPO='F'
	BEGIN
	
		if left(@fatura_pc,2)='BO' and (len(@Fatura_PC) = 17 or len(@fatura_pc)=16)
			BEGIN
				insert @table
					SELECT 
						Top 1
						Data_PC,
						fatDtVenc,
						Obs_PC OBS,
						right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ,
						Fatura_PC,
						PP.Apelido,
						PP.Nome_Raz_Soc,
						RUA,
						Numero,
						Cidade,
						UF,
						max(Numero_PO_HBO) Referencia_Cliente,
						DI_RE_PC,
						''Origem,
						'' Destino,
						'' House,
						NULL CD_TP_TX,
						NULL NOME_TP_TX,
						NULL VLR_PC,
						TP_PGTO,
						'' OBS_HOU,
						CNS.Nome_Raz_Soc CNS,
						LDE.Nome_Local Local_Desemb,
						dbo.fBusca_Tarefa(HOU.Num_Proc_HBO,4) Dt_Desembaraco,
						fatDtVenc Vencimento,
						Max(CCH.Num_NF_HBO) num_nf,
						isnull(Ordem,99) Order_By
					FROM 
						FATURA_CHB FAT
						JOIN FATURA_CHB_ITEM ITM ON ITM.FATURA_CC=FAT.FATURA_PC
						JOIN PESSOA PP ON PP.CD_PES=CD_PES_PC 
						LEFT Join Endereco ED on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
						LEFT JOIN House_BDP_OUT HOU ON HOU.Num_Proc_HBO=LEFT(FATURA_PC,16)
						LEFT JOIN Cta_Cte_HOU_BDP_OUT CCH on CCH.Num_Proc_HBO = LEFT(FATURA_PC,16) and CCH.Num_NF_HBO is not null AND CCH.Ref_Acesso_NF_HBO <> 'P' AND CCH.Ref_Acesso_NF_HBO is not null
						join Tipo_Taxa TT on TT.cd_tp_Tx=itm.cd_tp_Tx
						LEft Join PO_HBO PO on lefT(fat.fatura_pc,16)=po.num_proC_HBO AND ID_DC = 1
						--Join Localidade Org on Org.cd_local=cd_org_HEO
						--Join Localidade dst on dst.cd_local=cd_dst_HEO
						left join Pessoa CNS on CNS.cd_pes = HOU.cd_cliente_hbo
						Left Join Campo_Processo CP on CP.Num_Proc=left(@Fatura_PC,16) and Id_Campo=25
						Left Join Localidade LDE on LDE.cd_local=CP.Campo_Dados
						Left Join Fatura on fatcod=fatura_pc
						Left Join Tipo_Taxa_PC_CHB TCHB on TCHB.cd_tp_tx=TT.cd_tp_tx and cd_pes_grupo=@cd_pes
					WHERE 
						FATURA_PC=@FATURA_PC --and imprime='S'
					group by 
						HOU.Num_Proc_HBO, Data_pc,fatdtvenc,Obs_Pc,
						--Obs_Heo,
						right(PP.Num_CPF_CNPJ,14),Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,
						--org.nome_local , dst.nome_local ,hawb_HEO ,
						ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, CNS.Nome_Raz_Soc, LDE.Nome_Local,Ordem
					Order by order_by
			END
	

	    if left(@fatura_pc,2)='EO' and (len(@Fatura_PC) = 17 or len(@fatura_pc)=16)
		BEGIN
			insert @table
			SELECT 
				Top 1
				Data_PC,
				fatDtVenc,
				Obs_PC OBS,
				right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ,
				Fatura_PC,
				PP.Apelido,
				PP.Nome_Raz_Soc,
				RUA,
				Numero,
				Cidade,
				UF,
				max(Numero_PO_HEO) Referencia_Cliente,
				DI_RE_PC,
				org.nome_local Origem,
				dst.nome_local Destino,
				hawb_HEO House,
				NULL CD_TP_TX,
				NULL NOME_TP_TX,
				NULL VLR_PC,
				TP_PGTO,
				Obs_heo OBS_HOU,
				CNS.Nome_Raz_Soc CNS,
				LDE.Nome_Local Local_Desemb,
				dbo.fBusca_Tarefa(HOU.Num_Proc_HEO,4) Dt_Desembaraco,
				fatDtVenc Vencimento,
				Max(CCH.num_nf_heo) num_nf,
				isnull(Ordem,99) Order_By
			FROM 
				FATURA_CHB FAT
				JOIN FATURA_CHB_ITEM ITM ON ITM.FATURA_CC=FAT.FATURA_PC
				JOIN PESSOA PP ON PP.CD_PES=CD_PES_PC 
				LEFT Join Endereco ED on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
				LEFT JOIN HOUSE_EXP_OUT HOU ON HOU.NUM_PROC_HEO=LEFT(FATURA_PC,16)
				LEFT JOIN cta_cte_hou_exp_out CCH on CCH.num_proc_heo = LEFT(FATURA_PC,16) and CCH.num_nf_heo is not null AND CCH.REF_ACESSO_NF_Heo <> 'P' AND CCH.REF_ACESSO_NF_Heo is not null
				join Tipo_Taxa TT on TT.cd_tp_Tx=itm.cd_tp_Tx
				LEft Join PO_HEO PO on lefT(fat.fatura_pc,16)=po.num_proC_HEO AND ID_DC = 1
				Join Localidade Org on Org.cd_local=cd_org_HEO
				Join Localidade dst on dst.cd_local=cd_dst_HEO
				left join Pessoa CNS on CNS.cd_pes = HOU.cd_export_HEO
				Left Join Campo_Processo CP on CP.Num_Proc=left(@Fatura_PC,16) and Id_Campo=25
				Left Join Localidade LDE on LDE.cd_local=CP.Campo_Dados
				Left Join Fatura on fatcod=fatura_pc
				Left Join Tipo_Taxa_PC_CHB TCHB on TCHB.cd_tp_tx=TT.cd_tp_tx and cd_pes_grupo=@cd_pes
			WHERE 
				FATURA_PC=@FATURA_PC --and imprime='S'
			group by 
				HOU.Num_Proc_HEO, Data_pc,fatdtvenc,Obs_Pc,Obs_Heo,right(PP.Num_CPF_CNPJ,14),Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,hawb_HEO ,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, CNS.Nome_Raz_Soc, LDE.Nome_Local,Ordem
			Order by order_by
		END

	    if left(@fatura_pc,2)='IO' and (len(@Fatura_PC) = 17 or len(@fatura_pc)=16)
		BEGIN
		insert @table
			SELECT 
				Top 1
				Data_PC,fatdtvenc,Obs_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ ,Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,RUA,Numero,Cidade,UF,max(Numero_PO_HIO) Referencia_Cliente,DI_RE_PC,org.nome_local Origem, dst.nome_local Destino,hawb_HIO House,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO,Obs_hio OBS_HOU, CNS.Nome_Raz_Soc CNS, LDE.Nome_Local Local_Desemb,
				dbo.fBusca_Tarefa(HOU.Num_Proc_HIO,4) Dt_Desembaraco,fatDtVenc Vencimento, MAx(cch.num_nf_hio) num_nf,isnull(Ordem,99) Order_By
			FROM 
				FATURA_CHB FAT
				JOIN FATURA_CHB_ITEM ITM ON ITM.FATURA_CC=FAT.FATURA_PC
				JOIN PESSOA PP ON PP.CD_PES=CD_PES_PC 
				LEFT Join Endereco ED on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
				LEFT JOIN HOUSE_IMP_OUT HOU ON HOU.NUM_PROC_HIO=LEFT(FATURA_PC,16)
				LEFT JOIN cta_cte_hou_imp_out CCH on CCH.num_proc_hio = LEFT(FATURA_PC,16) and CCH.num_nf_hio is not null AND CCH.REF_ACESSO_NF_HIo <> 'P' AND CCH.REF_ACESSO_NF_Hio is not null
				join Tipo_Taxa TT on TT.cd_tp_Tx=itm.cd_tp_Tx
				LEft Join PO_HIO PO on lefT(fat.fatura_pc,16)=po.num_proC_HIO AND ID_DC = 1
				Join Localidade Org on Org.cd_local=cd_org_HIO
				Join Localidade dst on dst.cd_local=cd_dst_HIO
				left join Pessoa CNS on CNS.cd_pes = HOU.cd_consig_HIO
				Left Join Campo_Processo CP on CP.Num_Proc=left(@Fatura_PC,16) and Id_Campo=25
				Left Join Localidade LDE on LDE.cd_local=CP.Campo_Dados
				Left Join Fatura on fatcod=fatura_pc
				Left Join Tipo_Taxa_PC_CHB TCHB on TCHB.cd_tp_tx=TT.cd_tp_tx and cd_pes_grupo=@cd_pes
			WHERE 
				FATURA_PC=@FATURA_PC --and imprime='S'
			group by 
				HOU.Num_Proc_HIO,Data_PC,fatdtvenc,Obs_PC,obs_hio,right(PP.Num_CPF_CNPJ,14),Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,hawb_HIO ,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, CNS.Nome_Raz_Soc, LDE.Nome_Local,Ordem
			Order by order_by
		END

	    if left(@fatura_pc,2)='IM' and (len(@Fatura_PC) = 17 or len(@Fatura_PC) = 16)
		BEGIN
			insert @table
			SELECT 
				Top 1
				Data_PC,fatdtvenc,OBS_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ ,Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,RUA,Numero,Cidade,UF,max(Numero_PO_HIM) Referencia_Cliente,DI_RE_PC,org.nome_local Origem, dst.nome_local Destino,hawb_him House,NULL CD_TP_TX,NULL NOME_TP_TX,NULL VLR_PC, TP_PGTO, Obs_him OBS_HOU, CNS.Nome_Raz_Soc CNS, LDE.Nome_Local Local_Desemb,
				dbo.fBusca_Tarefa(HOU.Num_Proc_HIM,4) Dt_Desembaraco,fatDtVenc Vencimento,max(CCH.num_nf_him) num_nf,isnull(Ordem,99) Order_By
			FROM 
				FATURA_CHB FAT
				JOIN FATURA_CHB_ITEM ITM ON ITM.FATURA_CC=FAT.FATURA_PC
				JOIN PESSOA PP ON PP.CD_PES=CD_PES_PC
				LEFT Join Endereco ED on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
				LEFT JOIN HOUSE_IMP_MAR HOU ON HOU.NUM_PROC_HIM=LEFT(FATURA_PC,16)
				LEFT JOIN cta_cte_hou_imp_mar CCH on CCH.num_proc_him = LEFT(FATURA_PC,16) and CCH.num_nf_him is not null AND CCH.REF_ACESSO_NF_HIM <> 'P' AND CCH.REF_ACESSO_NF_Him is not null
				join Tipo_Taxa TT on TT.cd_tp_Tx=itm.cd_tp_Tx
				LEft Join PO_HIM PO on lefT(fat.fatura_pc,16)=po.num_proC_him AND ID_DC = 1
				Join Localidade Org on Org.cd_local=cd_org_him
				Join Localidade dst on dst.cd_local=cd_dst_him
				left join Pessoa CNS on CNS.cd_pes = HOU.cd_consig_HIM
				Left Join Campo_Processo CP on CP.Num_Proc=left(@Fatura_PC,16) and Id_Campo=25
				Left Join Localidade LDE on LDE.cd_local=CP.Campo_Dados
				Left Join Fatura on fatcod=fatura_pc
				Left Join Tipo_Taxa_PC_CHB TCHB on TCHB.cd_tp_tx=TT.cd_tp_tx and cd_pes_grupo=@cd_pes
			WHERE 
				FATURA_PC=@FATURA_PC-- and imprime='S'
			group by 
				HOU.Num_Proc_HIM,Data_PC,fatdtvenc,Obs_PC,obs_him,right(pp.Num_CPF_CNPJ,14),Fatura_PC,pp.Apelido,pp.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,hawb_him ,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, CNS.Nome_Raz_Soc, LDE.Nome_Local,Ordem
			Order by order_by
			END
		
		IF left(@fatura_pc,2)='IA' and (len(@Fatura_PC) = 17 or len(@fatura_pc)=16)
			BEGIN
				insert @table
				SELECT Top 1
					Data_PC,fatdtvenc,Obs_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ, Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,RUA,Numero,Cidade,UF, max(Numero_PO_hia) Referencia_Cliente,DI_RE_PC,org.nome_local Origem, dst.nome_local Destino,hawb_hia House,NULL CD_TP_TX,NULL NOME_TP_TX,NULL VLR_PC, TP_PGTO, Obs_hia OBS_HOU, CNS.Nome_Raz_Soc CNS, LDE.Nome_Local Local_Desemb,
					dbo.fBusca_Tarefa(HOU.Num_Proc_HIA,4) Dt_Desembaraco,fatDtVenc Vencimento, Max(cch.num_nf_hia) num_nf,isnull(Ordem,99) Order_By
				FROM 
					FATURA_CHB FAT
					JOIN FATURA_CHB_ITEM ITM ON ITM.FATURA_CC=FAT.FATURA_PC
					JOIN PESSOA PP ON PP.CD_PES=CD_PES_PC
					LEFT Join Endereco ED on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
					LEFT JOIN HOUSE_IMP_aer HOU ON HOU.NUM_PROC_hia=LEFT(FATURA_PC,16)
					LEFT JOIN cta_cte_hou_imp_aer CCH on CCH.num_proc_hia = LEFT(FATURA_PC,16) and CCH.num_nf_hia is not null AND CCH.REF_ACESSO_NF_HIa <> 'P' AND CCH.REF_ACESSO_NF_Hia is not null
					join Tipo_Taxa TT on TT.cd_tp_Tx=itm.cd_tp_Tx
					LEft Join PO_hia PO on lefT(fat.fatura_pc,16)=po.num_proC_hia  AND ID_DC = 1
					Join Localidade Org on Org.cd_local=cd_org_hia
					Join Localidade dst on dst.cd_local=cd_dst_hia
					left join Pessoa CNS on CNS.cd_pes = HOU.cd_consig_HIA
					Left Join Campo_Processo CP on CP.Num_Proc=left(@Fatura_PC,16) and Id_Campo=25
					Left Join Localidade LDE on LDE.cd_local=CP.Campo_Dados
					Left Join Fatura on fatcod=fatura_pc
					Left Join Tipo_Taxa_PC_CHB TCHB on TCHB.cd_tp_tx=TT.cd_tp_tx and cd_pes_grupo=@cd_pes
				WHERE 
					FATURA_PC=@FATURA_PC-- and imprime='S'
				group by 
					HOU.Num_Proc_HIA,Data_PC,fatdtvenc,obs_PC,obs_hia,right(pp.Num_CPF_CNPJ,14), Fatura_PC,pp.Apelido,pp.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,hawb_hia ,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, CNS.Nome_Raz_Soc, LDE.Nome_Local,Ordem
				Order by order_by
			END		
		IF left(@fatura_pc,2)='EM' and (len(@Fatura_PC) = 17 or len(@fatura_pc)=16)
			BEGIN
				insert @table
				SELECT Top 1
					Data_PC,fatdtvenc,OBS_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ ,Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,RUA,Numero,Cidade,UF,max(Numero_PO_HEM) Referencia_Cliente,DI_RE_PC,org.nome_local Origem, dst.nome_local Destino,hawb_HEM House,NULL CD_TP_TX,NULL NOME_TP_TX,NULL VLR_PC, TP_PGTO, Obs_hem OBS_HOU, CNS.Nome_Raz_Soc CNS, LDE.Nome_Local Local_Desemb,
					dbo.fBusca_Tarefa(HOU.Num_Proc_HEM,4) Dt_Desembaraco,fatDtVenc Vencimento, max(cch.num_nf_hem) num_nf,isnull(Ordem,99) Order_By
				FROM 
					FATURA_CHB FAT
					JOIN FATURA_CHB_ITEM ITM ON ITM.FATURA_CC=FAT.FATURA_PC
					JOIN PESSOA PP ON PP.CD_PES=CD_PES_PC
					LEFT Join Endereco ED on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
					LEFT JOIN HOUSE_EXP_MAR HOU ON HOU.NUM_PROC_HEM=LEFT(FATURA_PC,16)
					LEFT JOIN cta_cte_hou_exp_mar CCH on CCH.num_proc_hem = LEFT(FATURA_PC,16) 
					and CCH.num_nf_hem is not null AND CCH.REF_ACESSO_NF_HeM <> 'P'
					join Tipo_Taxa TT on TT.cd_tp_Tx=itm.cd_tp_Tx
					LEft Join PO_HEM PO on lefT(fat.fatura_pc,16)=po.num_proC_HEM AND ID_DC = 1
					Join Localidade Org on Org.cd_local=cd_org_HEM
					Join Localidade dst on dst.cd_local=cd_dst_HEM
					left join Pessoa CNS on CNS.cd_pes = HOU.cd_export_HEM
					Left Join Campo_Processo CP on CP.Num_Proc=left(@Fatura_PC,16) and Id_Campo=25
					Left Join Localidade LDE on LDE.cd_local=CP.Campo_Dados
					Left Join Fatura on fatcod=fatura_pc
					Left Join Tipo_Taxa_PC_CHB TCHB on TCHB.cd_tp_tx=TT.cd_tp_tx and cd_pes_grupo=@cd_pes
				WHERE 
					FATURA_PC=@FATURA_PC --and IMPrime='S'
				group by 
					HOU.Num_Proc_HEM,Data_PC,fatdtvenc,OBS_PC,obs_hem,right(pp.Num_CPF_CNPJ,14),Fatura_PC,pp.Apelido,pp.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,hawb_HEM ,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, CNS.Nome_Raz_Soc, LDE.Nome_Local,Ordem
				Order by order_by
			END
		
		IF left(@fatura_pc,2)='EA' and (len(@Fatura_PC) = 17 or len(@fatura_pc)=16)
			BEGIN
			insert @table
				SELECT Top 1
					Data_PC,fatdtvenc,obs_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ, Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,RUA,Numero,Cidade,UF,max(Numero_PO_HEA) Referencia_Cliente,DI_RE_PC,org.nome_local Origem, dst.nome_local Destino,hawb_HEA House,NULL CD_TP_TX,NULL NOME_TP_TX,NULL VLR_PC, TP_PGTO, Obs_hea OBS_HOU, CNS.Nome_Raz_Soc CNS, LDE.Nome_Local Local_Desemb,
					dbo.fBusca_Tarefa(HOU.Num_Proc_HEA,4) Dt_Desembaraco,fatDtVenc Vencimento, Max(CCH.num_nf_hea) num_nf,isnull(Ordem,99) Order_By
				FROM 
					FATURA_CHB FAT
					JOIN FATURA_CHB_ITEM ITM ON ITM.FATURA_CC=FAT.FATURA_PC
					JOIN PESSOA PP ON PP.CD_PES=CD_PES_PC
					LEFT Join Endereco ED on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
					LEFT JOIN HOUSE_EXP_aer HOU ON HOU.NUM_PROC_HEA=LEFT(FATURA_PC,16)
					LEFT JOIN cta_cte_hou_exp_aer CCH on CCH.num_proc_hea = LEFT(FATURA_PC,16) and CCH.num_nf_hea is not null AND CCH.REF_ACESSO_NF_Hea <> 'P' AND CCH.REF_ACESSO_NF_Hea is not null
					join Tipo_Taxa TT on TT.cd_tp_Tx=itm.cd_tp_Tx
					LEft Join PO_HEA PO on lefT(fat.fatura_pc,16)=po.num_proC_HEA AND ID_DC = 1
					Join Localidade Org on Org.cd_local=cd_org_HEA
					Join  Localidade dst on dst.cd_local=cd_dst_HEA
					left join Pessoa CNS on CNS.cd_pes = HOU.cd_export_HEA
					Left Join Campo_Processo CP on CP.Num_Proc=left(@Fatura_PC,16) and Id_Campo=25
					Left Join Localidade LDE on LDE.cd_local=CP.Campo_Dados
					Left Join Fatura on fatcod=fatura_pc
					Left Join Tipo_Taxa_PC_CHB TCHB on TCHB.cd_tp_tx=TT.cd_tp_tx and cd_pes_grupo=@cd_pes
				where 
					FATURA_PC=@FATURA_PC-- and IMPrime='S'
				group by 
					HOU.Num_Proc_HEA,Data_PC,fatdtvenc,obs_PC,obs_hea,right(pp.Num_CPF_CNPJ,14), Fatura_PC,pp.Apelido,pp.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,hawb_HEA ,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, CNS.Nome_Raz_Soc, LDE.Nome_Local,Ordem
				Order by order_by
			END

		IF left(@fatura_pc,2)='EA' and (len(@Fatura_PC) = 15 or len(@fatura_pc)=14)
		
			BEGIN
			insert @table
				SELECT Top 1
					Data_PC,fatdtvenc,obs_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ, Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,RUA,Numero,Cidade,UF,max(Numero_PO) Referencia_Cliente,DI_RE_PC,org.nome_local Origem, dst.nome_local Destino,Mawb_MEA HOUSE,NULL CD_TP_TX,NULL NOME_TP_TX,NULL VLR_PC, TP_PGTO, Obs_MEA OBS_MAS, CNS.Nome_Raz_Soc CNS, LDE.Nome_Local Local_Desemb,
					dbo.fBusca_Tarefa(MAS.Num_Proc_MEA,4) Dt_Desembaraco,fatDtVenc Vencimento, 
					--MAx(CCM.NUM_NF_MeA)) num_nf
					(select max(num_nf_mea) from cta_cte_mas_exp_aer where num_proc_mea = LEFT(FATURA_PC,14)) num_nf,isnull(Ordem,99) Order_By
				FROM 
					FATURA_CHB FAT
					JOIN FATURA_CHB_ITEM ITM ON ITM.FATURA_CC=FAT.FATURA_PC
					JOIN PESSOA PP ON PP.CD_PES=CD_PES_PC
					LEFT Join Endereco ED on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
					LEFT JOIN MASTER_EXP_aer MAS ON MAS.NUM_PROC_MEA=LEFT(FATURA_PC,14)
					--LEFT join cta_cte_mas_exp_AER CCM on CCM.num_proc_meA = LEFT(FATURA_PC,14) and CCM.NUM_NF_MeA IS NOT NULL AND CCM.REF_ACESSO_NF_MeA <> 'P' AND CCM.REF_ACESSO_NF_MEA is not null
					join Tipo_Taxa TT on TT.cd_tp_Tx=itm.cd_tp_Tx
					LEft Join PO_Master PO on lefT(fat.fatura_pc,14)=po.num_proC_Master AND ID_DC = 1
					Join Localidade Org on Org.cd_local=cd_org_MEA
					Join  Localidade dst on dst.cd_local=cd_dst_MEA
					left join Pessoa CNS on CNS.cd_pes = MAS.cd_export_MEA
					Left Join Campo_Processo CP on CP.Num_Proc=left(@Fatura_PC,14) and Id_Campo=25
					Left Join Localidade LDE on LDE.cd_local=CP.Campo_Dados
					Left Join Fatura on fatcod=fatura_pc
					Left Join Tipo_Taxa_PC_CHB TCHB on TCHB.cd_tp_tx=TT.cd_tp_tx and cd_pes_grupo=@cd_pes
				where 
					FATURA_PC=@FATURA_PC --and IMPrime='S'
				group by 
					MAS.Num_Proc_MEA,Data_PC,fatdtvenc,obs_PC,obs_MEA,right(pp.Num_CPF_CNPJ,14), Fatura_PC,pp.Apelido,pp.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,Mawb_MEA ,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, CNS.Nome_Raz_Soc, LDE.Nome_Local,Ordem
				Order by order_by
			END
		IF left(@fatura_pc,2)='EM' and (len(@Fatura_PC) = 15 or len(@fatura_pc)=14)
		
			BEGIN
			insert @table
				SELECT Top 1
					Data_PC,fatdtvenc,obs_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ, Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,RUA,Numero,Cidade,UF,max(Numero_PO) Referencia_Cliente,DI_RE_PC,org.nome_local Origem, dst.nome_local Destino,Mawb_mem HOUSE,NULL CD_TP_TX,NULL NOME_TP_TX,NULL VLR_PC, TP_PGTO, Obs_mem OBS_MAS, CNS.Nome_Raz_Soc CNS, LDE.Nome_Local Local_Desemb,
					dbo.fBusca_Tarefa(MAS.Num_Proc_MEM,4) Dt_Desembaraco,fatDtVenc Vencimento, 
					--Max(CCM.NUM_NF_Mem) num_nf
					(select max(num_nf_mem) from cta_cte_mas_exp_mar where num_proc_mem = LEFT(FATURA_PC,14)) num_nf,isnull(Ordem,99) Order_By
				FROM
					FATURA_CHB FAT
					JOIN FATURA_CHB_ITEM ITM ON ITM.FATURA_CC=FAT.FATURA_PC
					JOIN PESSOA PP ON PP.CD_PES=CD_PES_PC
					LEFT Join Endereco ED on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
					LEFT JOIN MASTER_EXP_mar MAS ON MAS.NUM_PROC_mem=LEFT(FATURA_PC,14)
					--LEFT join cta_cte_mas_exp_mar CCM on CCM.num_proc_mem = LEFT(FATURA_PC,14) and CCM.NUM_NF_MeM IS NOT NULL AND CCM.REF_ACESSO_NF_MeM <> 'P' AND CCM.REF_ACESSO_NF_MEM is not null
					join Tipo_Taxa TT on TT.cd_tp_Tx=itm.cd_tp_Tx
					LEft Join PO_Master PO on lefT(fat.fatura_pc,14)=po.num_proC_Master AND ID_DC = 1
					Join Localidade Org on Org.cd_local=cd_org_mem
					Join  Localidade dst on dst.cd_local=cd_dst_mem
					left join Pessoa CNS on CNS.cd_pes = MAS.cd_export_mem
					Left Join Campo_Processo CP on CP.Num_Proc=left(@Fatura_PC,14) and Id_Campo=25
					Left Join Localidade LDE on LDE.cd_local=CP.Campo_Dados
					Left Join Fatura on fatcod=fatura_pc
					Left Join Tipo_Taxa_PC_CHB TCHB on TCHB.cd_tp_tx=TT.cd_tp_tx and cd_pes_grupo=@cd_pes
				where 
					FATURA_PC=@FATURA_PC --and IMPrime='S'
				group by 
					MAS.Num_Proc_MEM,Data_PC,fatdtvenc,obs_PC,obs_mem,right(pp.Num_CPF_CNPJ,14), Fatura_PC,pp.Apelido,pp.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,Mawb_mem ,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, CNS.Nome_Raz_Soc, LDE.Nome_Local,Ordem
				Order by order_by
			END
		IF left(@fatura_pc,2)='IM' and (len(@Fatura_PC) = 15 OR len(@Fatura_PC) = 14)
			BEGIN
			insert @table
				SELECT Top 1
					Data_PC,fatdtvenc,obs_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ, Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,RUA,Numero,Cidade,UF,max(Numero_PO) Referencia_Cliente,DI_RE_PC,org.nome_local Origem, dst.nome_local Destino,Mawb_mim HOUSE,NULL CD_TP_TX,NULL NOME_TP_TX,NULL VLR_PC, TP_PGTO, Obs_mim OBS_MAS, CNS.Nome_Raz_Soc CNS, LDE.Nome_Local Local_Desemb, 
					dbo.fBusca_Tarefa(MAS.Num_Proc_MIM,4) Dt_Desembaraco,fatDtVenc Vencimento,
					--max(CCM.NUM_NF_MIM) num_nf
					(select max(num_nf_mim) from cta_cte_mas_imp_mar where num_proc_mim = LEFT(FATURA_PC,14)) num_nf,isnull(Ordem,99) Order_By
				FROM 
					FATURA_CHB FAT
					JOIN FATURA_CHB_ITEM ITM ON ITM.FATURA_CC=FAT.FATURA_PC
					JOIN PESSOA PP ON PP.CD_PES=CD_PES_PC
					LEFT Join Endereco ED on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
					LEFT JOIN MASTER_imp_mar MAS ON MAS.NUM_PROC_mim=LEFT(FATURA_PC,14)
					--LEFT join cta_cte_mas_imp_mar CCM on CCM.num_proc_mim = LEFT(FATURA_PC,14) and CCM.NUM_NF_MIM IS NOT NULL AND CCM.REF_ACESSO_NF_MIM <> 'P' AND CCM.REF_ACESSO_NF_MIM is not null
					join Tipo_Taxa TT on TT.cd_tp_Tx=itm.cd_tp_Tx
					LEft Join PO_Master PO on lefT(fat.fatura_pc,14)=po.num_proC_Master AND ID_DC = 1
					Join Localidade Org on Org.cd_local=cd_org_mim
					Join  Localidade dst on dst.cd_local=cd_dst_mim
					left join Pessoa CNS on CNS.cd_pes = MAS.cd_consig_mim
					Left Join Campo_Processo CP on CP.Num_Proc=left(@Fatura_PC,14) and Id_Campo=25
					Left Join Localidade LDE on LDE.cd_local=CP.Campo_Dados
					Left Join Fatura on fatcod=fatura_pc
					Left Join Tipo_Taxa_PC_CHB TCHB on TCHB.cd_tp_tx=TT.cd_tp_tx and cd_pes_grupo=@cd_pes
				where 
					FATURA_PC=@FATURA_PC --and IMPrime='S'
				group by 
					MAS.Num_Proc_MIM,Data_PC,fatdtvenc,obs_PC,obs_mim,right(pp.Num_CPF_CNPJ,14), Fatura_PC,pp.Apelido,pp.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,Mawb_mim ,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, CNS.Nome_Raz_Soc, LDE.Nome_Local,Ordem--,NUM_NF_MIM
				Order by order_by
			END
		IF left(@fatura_pc,2)='IA' and (len(@Fatura_PC) = 15 or len(@fatura_pc)=14)

			BEGIN
			insert @table
				SELECT Top 1
					Data_PC,fatdtvenc,obs_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ, Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,RUA,Numero,Cidade,UF,max(Numero_PO) Referencia_Cliente,DI_RE_PC,org.nome_local Origem, dst.nome_local Destino,Mawb_mia HOUSE,NULL CD_TP_TX,NULL NOME_TP_TX,NULL VLR_PC, TP_PGTO, Obs_mia OBS_MAS, CNS.Nome_Raz_Soc CNS, LDE.Nome_Local Local_Desemb,
					dbo.fBusca_Tarefa(MAS.Num_Proc_MIA,4) Dt_Desembaraco ,fatDtVenc Vencimento,
--					max(CCM.NUM_NF_MIA) num_nf
					(select max(num_nf_mia) from cta_cte_mas_imp_aer where num_proc_mia = LEFT(FATURA_PC,14)) num_nf,isnull(Ordem,99) Order_By
				FROM 
					FATURA_CHB FAT
					JOIN FATURA_CHB_ITEM ITM ON ITM.FATURA_CC=FAT.FATURA_PC
					JOIN PESSOA PP ON PP.CD_PES=CD_PES_PC
					LEFT Join Endereco ED on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
					LEFT JOIN MASTER_imp_aer MAS ON MAS.NUM_PROC_mia=LEFT(FATURA_PC,14)
					--LEFT join cta_cte_mas_imp_AER CCM on CCM.num_proc_miA = LEFT(FATURA_PC,14) and CCM.NUM_NF_MIA IS NOT NULL AND CCM.REF_ACESSO_NF_MIA <> 'P' AND CCM.REF_ACESSO_NF_MIA is not null
					join Tipo_Taxa TT on TT.cd_tp_Tx=itm.cd_tp_Tx
					LEft Join PO_Master PO on lefT(fat.fatura_pc,14)=po.num_proC_Master AND ID_DC = 1
					Join Localidade Org on Org.cd_local=cd_org_mia
					Join  Localidade dst on dst.cd_local=cd_dst_mia
					left join Pessoa CNS on CNS.cd_pes = MAS.cd_consig_mia
					Left Join Campo_Processo CP on CP.Num_Proc=left(@Fatura_PC,14) and Id_Campo=25
					Left Join Localidade LDE on LDE.cd_local=CP.Campo_Dados
					Left Join Fatura on fatcod=fatura_pc
					Left Join Tipo_Taxa_PC_CHB TCHB on TCHB.cd_tp_tx=TT.cd_tp_tx and cd_pes_grupo=@cd_pes
				where 
					FATURA_PC=@FATURA_PC --and IMPrime='S'
				group by 
					MAS.Num_Proc_MIA,Data_PC,fatdtvenc,obs_PC,obs_mia,right(pp.Num_CPF_CNPJ,14), Fatura_PC,pp.Apelido,pp.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,Mawb_mia ,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, CNS.Nome_Raz_Soc, LDE.Nome_Local,Ordem--NUM_NF_MIA
				Order by order_by
			END		
		end
ELSE
	BEGIN
	
		IF left(@fatura_pc,2)='BO' and len(@fatura_pc)=17
			BEGIN
			insert @table
				SELECT 
					Data_PC,fatdtvenc,obs_pc OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ, Fatura_PC,PP.Apelido,
					PP.Nome_Raz_Soc,RUA,Numero,Cidade,UF,max(Numero_PO_HBO) Referencia_Cliente,DI_RE_PC,
					'' Origem, 
					'' Destino,
					'' House,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, 
					'' OBS_HOU, CNS.Nome_raz_soc CNS, LDE.Nome_Local Local_Desemb,
					dbo.fBusca_Tarefa(HOU.Num_Proc_HBO,4) Dt_Desembaraco, fatDtVenc Vencimento, CCH.Num_NF_HBO num_nf,isnull(Ordem,99) Order_By
				FROM 
					FATURA_CHB FAT
					JOIN FATURA_CHB_ITEM ITM ON ITM.FATURA_CC=FAT.FATURA_PC
					JOIN PESSOA PP ON PP.CD_PES=CD_PES_PC
					LEFT Join Endereco ED on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
					LEFT JOIN House_BDP_OUT HOU ON HOU.Num_Proc_HBO=LEFT(FATURA_PC,16)
					LEFT JOIN Cta_Cte_HOU_BDP_OUT CCH on CCH.Num_Proc_HBO = LEFT(FATURA_PC,16) and CCH.Num_NF_HBO is not null AND CCH.Ref_Acesso_NF_HBO <> 'P' AND CCH.Ref_Acesso_NF_HBO is not null
					join Tipo_Taxa TT on TT.cd_tp_Tx=itm.cd_tp_Tx
					LEft Join PO_HBO PO on lefT(fat.fatura_pc,16)=po.Num_Proc_HBO AND ID_DC = 1
					--Left Join Localidade Org on Org.cd_local=cd_org_HEO
					--Left Join Localidade dst on dst.cd_local=cd_dst_HEO
					left join Pessoa CNS on CNS.cd_pes = HOU.cd_cliente_hbo
					Left Join Campo_Processo CP on CP.Num_Proc=left(@Fatura_PC,16) and Id_Campo=25
					Left Join Localidade LDE on LDE.cd_local=CP.Campo_Dados
					Left Join Fatura on fatcod=fatura_pc
					Left Join Tipo_Taxa_PC_CHB TCHB on TCHB.cd_tp_tx=TT.cd_tp_tx and cd_pes_grupo=@cd_pes
				WHERE 
					FATURA_PC=@FATURA_PC 
				group by 
					HOU.Num_Proc_HBO,Data_PC,fatdtvenc,obs_pc,
					--obs_heo,
					right(pp.Num_CPF_CNPJ,14), Fatura_PC,pp.Apelido,pp.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,
					--org.nome_local , dst.nome_local ,hawb_HEO ,
					ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, CNS.Nome_raz_Soc, LDE.Nome_Local,Num_NF_HBO,Ordem
				Order by order_by
			END
	
		IF left(@fatura_pc,2)='IM' and (len(@fatura_pc)=17 or len(@fatura_pc)=16)
			BEGIN
			insert @table
				SELECT 
					Data_PC,fatdtvenc,OBS_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ, Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,RUA,Numero,Cidade,UF,max(Numero_PO_HIM) Referencia_Cliente,DI_RE_PC,org.nome_local Origem, dst.nome_local Destino,hawb_him House,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, Obs_him OBS_HOU, CNS.Nome_Raz_Soc CNS, LDE.Nome_Local Local_Desemb,
					dbo.fBusca_Tarefa(HOU.Num_Proc_HIM,4) Dt_Desembaraco,fatDtVenc Vencimento,MAX(CCH.NUM_NF_HIM) num_nf,isnull(Ordem,99) Order_By
				FROM 
					FATURA_CHB FAT
					JOIN FATURA_CHB_ITEM ITM ON ITM.FATURA_CC=FAT.FATURA_PC
					JOIN PESSOA PP ON PP.CD_PES=CD_PES_PC
					LEFT Join Endereco ED on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
					LEFT JOIN HOUSE_IMP_MAR HOU ON HOU.NUM_PROC_HIM=LEFT(FATURA_PC,16)
					LEFT JOIN cta_cte_hou_imp_mar CCH on CCH.num_proc_him = LEFT(FATURA_PC,16) and CCH.num_nf_him is not null AND CCH.REF_ACESSO_NF_HIM <> 'P' AND CCH.REF_ACESSO_NF_Him is not null
					join Tipo_Taxa TT on TT.cd_tp_Tx=itm.cd_tp_Tx
					LEft Join PO_HIM PO on lefT(fat.fatura_pc,16)=po.num_proC_him AND ID_DC = 1
					Join Localidade Org on Org.cd_local=cd_org_him
					Join Localidade dst on dst.cd_local=cd_dst_him
					left join Pessoa CNS on CNS.cd_pes = HOU.cd_consig_HIM
					Left Join Campo_Processo CP on CP.Num_Proc=left(@Fatura_PC,16) and Id_Campo=25
					Left Join Localidade LDE on LDE.cd_local=CP.Campo_Dados
					Left Join Fatura on fatcod=fatura_pc
					Left Join Tipo_Taxa_PC_CHB TCHB on TCHB.cd_tp_tx=TT.cd_tp_tx and cd_pes_grupo=@cd_pes
				WHERE 
					FATURA_PC=@FATURA_PC 
				group by 
					HOU.Num_Proc_HIM,Data_PC,fatdtvenc,Obs_PC,obs_him,right(pp.Num_CPF_CNPJ,14), Fatura_PC,pp.Apelido,pp.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,hawb_him ,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, CNS.Nome_Raz_Soc, LDE.Nome_Local,Ordem
				Order by order_by
			End

		IF left(@fatura_pc,2)='IA' and (len(@fatura_pc)=17 or len(@fatura_pc)=16)
			BEGIN
			insert @table
				SELECT 
					Data_PC,fatdtvenc,Obs_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ, Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,RUA,Numero,Cidade,UF,max(Numero_PO_hia) Referencia_Cliente,DI_RE_PC,org.nome_local Origem, dst.nome_local Destino,hawb_hia House,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, Obs_hia OBS_HOU, CNS.Nome_Raz_Soc CNS, LDE.Nome_Local Local_Desemb,
					dbo.fBusca_Tarefa(HOU.Num_Proc_HIA,4) Dt_Desembaraco,fatDtVenc Vencimento, max(CCH.num_nf_hia) num_nf,isnull(Ordem,99) Order_By
				FROM 
					FATURA_CHB FAT
					JOIN FATURA_CHB_ITEM ITM ON ITM.FATURA_CC=FAT.FATURA_PC
					JOIN PESSOA PP ON PP.CD_PES=CD_PES_PC
					LEFT Join Endereco ED on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
					LEFT JOIN HOUSE_IMP_aer HOU ON HOU.NUM_PROC_hia=LEFT(FATURA_PC,16)
					LEFT JOIN cta_cte_hou_imp_aer CCH on CCH.num_proc_hia = LEFT(FATURA_PC,16) and CCH.num_nf_hia is not null AND CCH.REF_ACESSO_NF_HIa <> 'P' AND CCH.REF_ACESSO_NF_Hia is not null
					join Tipo_Taxa TT on TT.cd_tp_Tx=itm.cd_tp_Tx
					LEft Join PO_hia PO on lefT(fat.fatura_pc,16)=po.num_proC_hia AND ID_DC=1
					Left Join Localidade Org on Org.cd_local=cd_org_hia
					Left Join Localidade dst on dst.cd_local=cd_dst_hia
					left join Pessoa CNS on CNS.cd_pes = HOU.cd_consig_HIA
					Left Join Campo_Processo CP on CP.Num_Proc=left(@Fatura_PC,16) and Id_Campo=25
					Left Join Localidade LDE on LDE.cd_local=CP.Campo_Dados
					Left Join Fatura on fatcod=fatura_pc
					Left Join Tipo_Taxa_PC_CHB TCHB on TCHB.cd_tp_tx=TT.cd_tp_tx and cd_pes_grupo=@cd_pes
				WHERE 
					FATURA_PC=@FATURA_PC 
				group by 
					HOU.Num_Proc_HIA,Data_PC,fatdtvenc,Obs_PC,obs_hia,right(pp.Num_CPF_CNPJ,14), Fatura_PC,pp.Apelido,pp.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,hawb_hia ,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, CNS.Nome_Raz_Soc, LDE.Nome_Local,Ordem
				Order by order_by
			END
		
		IF left(@fatura_pc,2)='EM' and len(@fatura_pc)=17
			BEGIN
			insert @table
				SELECT 
					Data_PC,fatdtvenc,OBS_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ, Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,RUA,Numero,Cidade,UF,max(Numero_PO_HEM) Referencia_Cliente,DI_RE_PC,org.nome_local Origem, dst.nome_local Destino,hawb_HEM House,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, Obs_hem OBS_HOU, CNS.Nome_raz_Soc CNS, LDE.Nome_Local Local_Desemb,
					dbo.fBusca_Tarefa(HOU.Num_Proc_HEM,4) Dt_Desembaraco ,fatDtVenc Vencimento,max(CCH.num_nf_hem) num_nf,isnull(Ordem,99) Order_By
				FROM 
					FATURA_CHB FAT
					JOIN FATURA_CHB_ITEM ITM ON ITM.FATURA_CC=FAT.FATURA_PC
					JOIN PESSOA PP ON PP.CD_PES=CD_PES_PC
					LEFT Join Endereco ED on ED.cd_pes=cd_pes_PC and ED.cd_tp_end='COM'
					LEFT JOIN HOUSE_EXP_MAR HOU ON HOU.NUM_PROC_HEM=LEFT(FATURA_PC,16)
					LEFT JOIN cta_cte_hou_exp_mar CCH on CCH.num_proc_hem = LEFT(FATURA_PC,16) and CCH.num_nf_hem is not null AND CCH.REF_ACESSO_NF_Hem <> 'P' AND CCH.REF_ACESSO_NF_Hem is not null
					join Tipo_Taxa TT on TT.cd_tp_Tx=itm.cd_tp_Tx
					LEft Join PO_HEM PO on lefT(fat.fatura_pc,16)=po.num_proC_HEM AND ID_DC = 1
					Left Join Localidade Org on Org.cd_local=cd_org_HEM
					Left Join Localidade dst on dst.cd_local=cd_dst_HEM
					left join Pessoa CNS on CNS.cd_pes = HOU.cd_export_HEM
					Left Join Campo_Processo CP on CP.Num_Proc=left(@Fatura_PC,16) and Id_Campo=25
					Left Join Localidade LDE on LDE.cd_local=CP.Campo_Dados
					Left Join Fatura on fatcod=fatura_pc
					Left Join Tipo_Taxa_PC_CHB TCHB on TCHB.cd_tp_tx=TT.cd_tp_tx and cd_pes_grupo=@cd_pes
				WHERE 
					FATURA_PC=@FATURA_PC
				group by 
					HOU.Num_Proc_HEM,Data_PC,fatdtvenc,OBS_PC,Obs_Hem,right(pp.Num_CPF_CNPJ,14), Fatura_PC,pp.Apelido,pp.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,hawb_HEM ,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, CNS.Nome_Raz_Soc, LDE.Nome_Local,Ordem
				Order by order_by
			END

		IF left(@fatura_pc,2)='EA' and len(@fatura_pc)=17
			BEGIN
			insert @table
				SELECT 
					Data_PC,fatdtvenc,obs_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ, Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,RUA,Numero,Cidade,UF,max(Numero_PO_HEA) Referencia_Cliente,DI_RE_PC,org.nome_local Origem, dst.nome_local Destino,hawb_HEA House,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, Obs_hea OBS_HOU, CNS.Nome_Raz_Soc CNS, LDE.Nome_Local Local_Desemb,
					dbo.fBusca_Tarefa(HOU.Num_Proc_HEA,4) Dt_Desembaraco,fatDtVenc Vencimento,CCH.num_nf_hea num_nf,isnull(Ordem,99) Order_By
				FROM
					FATURA_CHB FAT
					JOIN FATURA_CHB_ITEM ITM ON ITM.FATURA_CC=FAT.FATURA_PC
					JOIN PESSOA PP ON PP.CD_PES=CD_PES_PC
					LEFT Join Endereco ED on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
					LEFT JOIN HOUSE_EXP_aer HOU ON HOU.NUM_PROC_HEA=LEFT(FATURA_PC,16)
					LEFT JOIN cta_cte_hou_exp_aer CCH on CCH.num_proc_hea = LEFT(FATURA_PC,16) and CCH.num_nf_hea is not null AND CCH.REF_ACESSO_NF_Hea <> 'P' AND CCH.REF_ACESSO_NF_Hea is not null
					join Tipo_Taxa TT on TT.cd_tp_Tx=itm.cd_tp_Tx
					LEft Join PO_HEA PO on lefT(fat.fatura_pc,16)=po.num_proC_HEA AND ID_DC = 1
					Left Join Localidade Org on Org.cd_local=cd_org_HEA
					Left Join Localidade dst on dst.cd_local=cd_dst_HEA
					left join Pessoa CNS on CNS.cd_pes = HOU.cd_export_HEA
					Left Join Campo_Processo CP on CP.Num_Proc=left(@Fatura_PC,16) and Id_Campo=25
					Left Join Localidade LDE on LDE.cd_local=CP.Campo_Dados
					Left Join Fatura on fatcod=fatura_pc
					Left Join Tipo_Taxa_PC_CHB TCHB on TCHB.cd_tp_tx=TT.cd_tp_tx and cd_pes_grupo=@cd_pes
				WHERE 
					FATURA_PC=@FATURA_PC
				group by 
					HOU.Num_Proc_HEA,Data_PC,fatdtvenc,obs_PC,obs_hea,right(pp.Num_CPF_CNPJ,14), Fatura_PC,pp.Apelido,pp.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,hawb_HEA ,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, CNS.Nome_Raz_Soc, LDE.Nome_Local,CCH.num_nf_hea ,Ordem
				Order by order_by
			END
			
		IF left(@fatura_pc,2)='EO' and len(@fatura_pc)=17
			BEGIN
			insert @table
				SELECT 
					Data_PC,fatdtvenc,obs_pc OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ, Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,RUA,Numero,Cidade,UF,max(Numero_PO_HEO) Referencia_Cliente,DI_RE_PC,org.nome_local Origem, dst.nome_local Destino,hawb_HEO House,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, Obs_heo OBS_HOU, CNS.Nome_raz_soc CNS, LDE.Nome_Local Local_Desemb,
					dbo.fBusca_Tarefa(HOU.Num_Proc_HEO,4) Dt_Desembaraco, fatDtVenc Vencimento, CCH.num_nf_heo num_nf,isnull(Ordem,99) Order_By
				FROM 
					FATURA_CHB FAT
					JOIN FATURA_CHB_ITEM ITM ON ITM.FATURA_CC=FAT.FATURA_PC
					JOIN PESSOA PP ON PP.CD_PES=CD_PES_PC
					LEFT Join Endereco ED on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
					LEFT JOIN HOUSE_EXP_out HOU ON HOU.NUM_PROC_HEO=LEFT(FATURA_PC,16)
					LEFT JOIN cta_cte_hou_exp_out CCH on CCH.num_proc_heo = LEFT(FATURA_PC,16) and CCH.num_nf_heo is not null AND CCH.REF_ACESSO_NF_Heo <> 'P' AND CCH.REF_ACESSO_NF_Heo is not null
					join Tipo_Taxa TT on TT.cd_tp_Tx=itm.cd_tp_Tx
					LEft Join PO_HEO PO on lefT(fat.fatura_pc,16)=po.num_proC_HEO AND ID_DC = 1
					Left Join Localidade Org on Org.cd_local=cd_org_HEO
					Left Join Localidade dst on dst.cd_local=cd_dst_HEO
					left join Pessoa CNS on CNS.cd_pes = HOU.cd_export_HEO
					Left Join Campo_Processo CP on CP.Num_Proc=left(@Fatura_PC,16) and Id_Campo=25
					Left Join Localidade LDE on LDE.cd_local=CP.Campo_Dados
					Left Join Fatura on fatcod=fatura_pc
					Left Join Tipo_Taxa_PC_CHB TCHB on TCHB.cd_tp_tx=TT.cd_tp_tx and cd_pes_grupo=@cd_pes
				WHERE 
					FATURA_PC=@FATURA_PC 
				group by 
					HOU.Num_Proc_HEO,Data_PC,fatdtvenc,obs_pc,obs_heo,right(pp.Num_CPF_CNPJ,14), Fatura_PC,pp.Apelido,pp.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,hawb_HEO ,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, CNS.Nome_raz_Soc, LDE.Nome_Local,num_nf_heo,Ordem
				Order by order_by
			END

		If left(@fatura_pc,2)='IO' and (len(@Fatura_PC) = 17 or len(@fatura_pc)=16)
			BEGIN
			insert @table
				SELECT 
					Data_PC,fatdtvenc,obs_pc OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ, Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,RUA,Numero,Cidade,UF,max(Numero_PO_HIO) Referencia_Cliente,DI_RE_PC,org.nome_local Origem, dst.nome_local Destino,hawb_HIO House,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, Obs_hio OBS_HOU, CNS.Nome_Raz_soc CNS, LDE.Nome_Local Local_Desemb,
					dbo.fBusca_Tarefa(HOU.Num_Proc_HIO,4) Dt_Desembaraco, fatDtVenc Vencimento, CCH.num_nf_hio num_nf,isnull(Ordem,99) Order_By
				FROM 
					FATURA_CHB FAT
					JOIN FATURA_CHB_ITEM ITM ON ITM.FATURA_CC=FAT.FATURA_PC
					JOIN PESSOA PP ON PP.CD_PES=CD_PES_PC
					LEFT Join Endereco ED on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
					LEFT JOIN HOUSE_IMP_out HOU ON HOU.NUM_PROC_HIO=LEFT(FATURA_PC,16)
					LEFT JOIN cta_cte_hou_imp_out CCH on CCH.num_proc_hio = LEFT(FATURA_PC,16) and CCH.num_nf_hio is not null AND CCH.REF_ACESSO_NF_Hio <> 'P' AND CCH.REF_ACESSO_NF_Hio is not null
					join Tipo_Taxa TT on TT.cd_tp_Tx=itm.cd_tp_Tx
					LEft Join PO_HIO PO on lefT(fat.fatura_pc,16)=po.num_proC_HIO AND ID_DC = 1
					Left Join Localidade Org on Org.cd_local=cd_org_HIO
					Left Join Localidade dst on dst.cd_local=cd_dst_HIO
					left join Pessoa CNS on CNS.cd_pes = HOU.cd_consig_HIO
					Left Join Campo_Processo CP on CP.Num_Proc=left(@Fatura_PC,16) and Id_Campo=25
					Left Join Localidade LDE on LDE.cd_local=CP.Campo_Dados
					Left Join Fatura on fatcod=fatura_pc
					Left Join Tipo_Taxa_PC_CHB TCHB on TCHB.cd_tp_tx=TT.cd_tp_tx and cd_pes_grupo=@cd_pes
				WHERE 
					FATURA_PC=@FATURA_PC 
				group by 
					HOU.Num_Proc_HIO,Data_PC,fatdtvenc,obs_pc,obs_hio,right(pp.Num_CPF_CNPJ,14), Fatura_PC,pp.Apelido,pp.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,hawb_HIO ,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, CNS.Nome_raz_Soc, LDE.Nome_Local,CCH.num_nf_hio,Ordem
				Order by order_by
			END
		IF left(@fatura_pc,2)='EA' and len(@fatura_pc)=15
			BEGIN
			insert @table
				SELECT 
					Data_PC,fatdtvenc,obs_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ, Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,RUA,Numero,Cidade,UF,max(Numero_PO) Referencia_Cliente,DI_RE_PC,org.nome_local Origem, dst.nome_local Destino,Mawb_mea House,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, Obs_mea OBS_HOU, CNS.Nome_Raz_Soc CNS, LDE.Nome_Local Local_Desemb,
					dbo.fBusca_Tarefa(MAS.Num_Proc_MEA,4) Dt_Desembaraco, fatDtVenc Vencimento,
--					max(CCM.NUM_NF_MEA) num_nf
					(select max(num_nf_mea) from cta_cte_mas_exp_aer where num_proc_mea = LEFT(FATURA_PC,14)) num_nf,isnull(Ordem,99) Order_By
				FROM 
					FATURA_CHB FAT
					JOIN FATURA_CHB_ITEM ITM ON ITM.FATURA_CC=FAT.FATURA_PC
					JOIN PESSOA PP ON PP.CD_PES=CD_PES_PC
					LEFT Join Endereco ED on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
					LEFT JOIN MASTER_EXP_aer MAS ON MAS.NUM_PROC_mea=LEFT(FATURA_PC,14)
					LEFT join cta_cte_mas_exp_aer CCM on CCM.num_proc_mEA = LEFT(FATURA_PC,14) and CCM.NUM_NF_MEA IS NOT NULL AND CCM.REF_ACESSO_NF_MEA <> 'P' AND CCM.REF_ACESSO_NF_MEA is not null
					join Tipo_Taxa TT on TT.cd_tp_Tx=itm.cd_tp_Tx
					LEft Join PO_Master PO on lefT(fat.fatura_pc,14)=po.num_proC_master AND ID_DC = 1
					Left Join Localidade Org on Org.cd_local=cd_org_mea
					Left Join Localidade dst on dst.cd_local=cd_dst_mea
					left join Pessoa CNS on CNS.cd_pes = MAS.cd_export_mea
					Left Join Campo_Processo CP on CP.Num_Proc=left(@Fatura_PC,14) and Id_Campo=25
					Left Join Localidade LDE on LDE.cd_local=CP.Campo_Dados
					Left Join Fatura on fatcod=fatura_pc
					Left Join Tipo_Taxa_PC_CHB TCHB on TCHB.cd_tp_tx=TT.cd_tp_tx and cd_pes_grupo=@cd_pes
				WHERE 
					FATURA_PC=@FATURA_PC 
				group by 
					MAS.Num_Proc_MEA,Data_PC,fatdtvenc,obs_PC,obs_mea,right(pp.Num_CPF_CNPJ,14), Fatura_PC,pp.Apelido,pp.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,Mawb_mea ,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, CNS.Nome_Raz_Soc, LDE.Nome_Local,CCM.NUM_NF_MEA,Ordem
				Order by order_by
			END
		IF left(@fatura_pc,2)='EM' and len(@fatura_pc)=15
			BEGIN
			insert @table
				SELECT 
					Data_PC,fatdtvenc,obs_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ, Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,RUA,Numero,Cidade,UF,max(Numero_PO) Referencia_Cliente,DI_RE_PC,org.nome_local Origem, dst.nome_local Destino,Mawb_mem House,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, Obs_mem OBS_HOU, CNS.Nome_Raz_Soc CNS, LDE.Nome_Local Local_Desemb,
					dbo.fBusca_Tarefa(MAS.Num_Proc_MEM,4) Dt_Desembaraco, fatDtVenc Vencimento, 
--					max(CCM.NUM_NF_MEM) num_nf
					(select max(num_nf_mem) from cta_cte_mas_exp_mar where num_proc_mem = LEFT(FATURA_PC,14)) num_nf,isnull(Ordem,99) Order_By
				FROM
					FATURA_CHB FAT
					JOIN FATURA_CHB_ITEM ITM ON ITM.FATURA_CC=FAT.FATURA_PC
					JOIN PESSOA PP ON PP.CD_PES=CD_PES_PC
					LEFT Join Endereco ED on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
					LEFT JOIN MASTER_EXP_mar MAS ON MAS.NUM_PROC_mem=LEFT(FATURA_PC,14)
					LEFT join cta_cte_mas_exp_mar CCM on CCM.num_proc_mEM = LEFT(FATURA_PC,14) and CCM.NUM_NF_MEM IS NOT NULL AND CCM.REF_ACESSO_NF_MEM <> 'P' AND CCM.REF_ACESSO_NF_MEM is not null
					join Tipo_Taxa TT on TT.cd_tp_Tx=itm.cd_tp_Tx
					LEft Join PO_Master PO on lefT(fat.fatura_pc,14)=po.num_proC_master AND ID_DC = 1
					Left Join Localidade Org on Org.cd_local=cd_org_mem
					Left Join Localidade dst on dst.cd_local=cd_dst_mem
					left join Pessoa CNS on CNS.cd_pes = MAS.cd_export_mem
					Left Join Campo_Processo CP on CP.Num_Proc=left(@Fatura_PC,14) and Id_Campo=25
					Left Join Localidade LDE on LDE.cd_local=CP.Campo_Dados
					Left Join Fatura on fatcod=fatura_pc
					Left Join Tipo_Taxa_PC_CHB TCHB on TCHB.cd_tp_tx=TT.cd_tp_tx and cd_pes_grupo=@cd_pes
				WHERE 
					FATURA_PC=@FATURA_PC 
				group by 
					MAS.Num_Proc_MEM,Data_PC,fatdtvenc,obs_PC,obs_mem,right(pp.Num_CPF_CNPJ,14), Fatura_PC,pp.Apelido,pp.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,Mawb_mem ,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, CNS.Nome_Raz_Soc, LDE.Nome_Local,CCM.NUM_NF_MEM,Ordem
				Order by order_by
			END
		IF left(@fatura_pc,2)='IM' and len(@fatura_pc)=15
			BEGIN
			insert @table
				SELECT 
					Data_PC,fatdtvenc,obs_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ, Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,RUA,Numero,Cidade,UF,max(Numero_PO) Referencia_Cliente,DI_RE_PC,org.nome_local Origem, dst.nome_local Destino,Mawb_mim House,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, Obs_mim OBS_HOU, CNS.Nome_Raz_Soc CNS, LDE.Nome_Local Local_Desemb,
					dbo.fBusca_Tarefa(MAS.Num_Proc_MIM,4) Dt_Desembaraco, fatDtVenc Vencimento,
--					max(CCM.NUM_NF_MIM) num_nf
					(select max(num_nf_mim) from cta_cte_mas_imp_mar where num_proc_mim = LEFT(FATURA_PC,14)) num_nf,isnull(Ordem,99) Order_By
				FROM
					FATURA_CHB FAT
					JOIN FATURA_CHB_ITEM ITM ON ITM.FATURA_CC=FAT.FATURA_PC
					JOIN PESSOA PP ON PP.CD_PES=CD_PES_PC
					LEFT Join Endereco ED on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
					LEFT JOIN MASTER_imp_mar MAS ON MAS.NUM_PROC_mim=LEFT(FATURA_PC,14)
					LEFT JOIN CTA_CTE_MAS_IMP_MAR CCM ON CCM.NUM_PROC_MIM = LEFT(FATURA_PC,14) AND CCM.NUM_NF_MIM IS NOT NULL AND CCM.REF_ACESSO_NF_MIM <> 'P' AND CCM.REF_ACESSO_NF_MIM is not null
					join Tipo_Taxa TT on TT.cd_tp_Tx=itm.cd_tp_Tx
					LEft Join PO_Master PO on lefT(fat.fatura_pc,14)=po.num_proC_master AND ID_DC = 1
					Left Join Localidade Org on Org.cd_local=cd_org_mim
					Left Join Localidade dst on dst.cd_local=cd_dst_mim
					left join Pessoa CNS on CNS.cd_pes = MAS.cd_consig_mim
					Left Join Campo_Processo CP on CP.Num_Proc=left(@Fatura_PC,14) and Id_Campo=25
					Left Join Localidade LDE on LDE.cd_local=CP.Campo_Dados
					Left Join Fatura on fatcod=fatura_pc
					Left Join Tipo_Taxa_PC_CHB TCHB on TCHB.cd_tp_tx=TT.cd_tp_tx and cd_pes_grupo=@cd_pes
				WHERE 
					FATURA_PC=@FATURA_PC 
				group by 
					MAS.Num_Proc_MIM,Data_PC,fatdtvenc,obs_PC,obs_mim,right(pp.Num_CPF_CNPJ,14), Fatura_PC,pp.Apelido,pp.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,Mawb_mim ,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, CNS.Nome_Raz_Soc, LDE.Nome_Local,CCM.NUM_NF_MIM,Ordem
				Order by order_by
			END
		IF left(@fatura_pc,2)='IA' and len(@fatura_pc)=15
			BEGIN
			insert @table
				SELECT 
					Data_PC,fatdtvenc,obs_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ, Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,RUA,Numero,Cidade,UF,max(Numero_PO) Referencia_Cliente,DI_RE_PC,org.nome_local Origem, dst.nome_local Destino,Mawb_mia House,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, Obs_mia OBS_HOU, CNS.Nome_Raz_Soc CNS, LDE.Nome_Local Local_Desemb,
					dbo.fBusca_Tarefa(MAS.Num_Proc_MIA,4) Dt_Desembaraco, fatDtVenc Vencimento, 
--					max(CCM.NUM_NF_MIA) num_nf
					(select max(num_nf_mia) from cta_cte_mas_imp_aer where num_proc_mia = LEFT(FATURA_PC,14)) num_nf,isnull(Ordem,99) Order_By
				FROM 
					FATURA_CHB FAT
					JOIN FATURA_CHB_ITEM ITM ON ITM.FATURA_CC=FAT.FATURA_PC
					JOIN PESSOA PP ON PP.CD_PES=CD_PES_PC
					LEFT Join Endereco ED on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
					LEFT JOIN MASTER_imp_aer MAS ON MAS.NUM_PROC_mia=LEFT(FATURA_PC,14)
					LEFT join cta_cte_mas_imp_AER CCM on CCM.num_proc_mIA = LEFT(FATURA_PC,14) and CCM.NUM_NF_MIA IS NOT NULL AND CCM.REF_ACESSO_NF_MIA <> 'P' AND CCM.REF_ACESSO_NF_MIA is not null
					join Tipo_Taxa TT on TT.cd_tp_Tx=itm.cd_tp_Tx
					LEft Join PO_Master PO on lefT(fat.fatura_pc,14)=po.num_proC_master AND ID_DC = 1
					Left Join Localidade Org on Org.cd_local=cd_org_mia
					Left Join Localidade dst on dst.cd_local=cd_dst_mia
					left join Pessoa CNS on CNS.cd_pes = MAS.cd_export_mia
					Left Join Campo_Processo CP on CP.Num_Proc=left(@Fatura_PC,14) and Id_Campo=25
					Left Join Localidade LDE on LDE.cd_local=CP.Campo_Dados
					Left Join Fatura on fatcod=fatura_pc
					Left Join Tipo_Taxa_PC_CHB TCHB on TCHB.cd_tp_tx=TT.cd_tp_tx and cd_pes_grupo=@cd_pes
				WHERE 
					FATURA_PC=@FATURA_PC 
				group by 
					MAS.Num_Proc_MIA,Data_PC,fatdtvenc,obs_PC,obs_mia,right(pp.Num_CPF_CNPJ,14), Fatura_PC,pp.Apelido,pp.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,Mawb_mia ,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, CNS.Nome_Raz_Soc, LDE.Nome_Local,CCM.NUM_NF_MIA,Ordem
				Order by order_by
			END

	END
		update  @Table set nome_tp_Tx='(-) IRRF 1.5%',order_by=999
		where nome_Tp_Tx like 'IRRF%'
		
		Update @table set nome_tp_Tx='(-) PIS/COFINS/CSLL 4.65%',order_by=999
		where nome_tp_tx like 'PIS%' and left(Cd_tp_Tx,1) <> 'X'
		
		Update @table set nome_tp_Tx='(-) PIS/COFINS/CSLL 4.65%',order_by=999
		where nome_tp_tx like 'Cofins%' and left(Cd_tp_Tx,1) <> 'X'
		
		Update @table set nome_tp_Tx='(-) PIS/COFINS/CSLL 4.65%',order_by=999
		where nome_tp_tx like 'CSLL%' and left(Cd_tp_Tx,1) <> 'X'
		
		Select 	
			Data_PC	,fatdtvenc ,OBS,Num_CPF_CNPJ ,	Fatura_PC,
			Apelido,Nome_raz_Soc,Rua,Numero,Cidade,
			UF,Referencia_Cliente,DI_RE_PC,Origem,Destino,
			House,max(cd_tp_Tx) CD_Tp_TX,Nome_Tp_TX,Sum(Vlr_PC) Vlr_PC,TP_PGTO,Obs_HOU,
			CNS,Local_Desemb,Dt_Desembaraco,Vencimento,
			Num_Nf,Order_by
		From
			@Table
		Group by
			Data_PC	,fatdtvenc ,OBS,Num_CPF_CNPJ ,	Fatura_PC,
			Apelido,Nome_raz_Soc,Rua,Numero,Cidade,
			UF,Referencia_Cliente,DI_RE_PC,Origem,Destino,
			House,Nome_Tp_TX,TP_PGTO,Obs_HOU,
			CNS,Local_Desemb,Dt_Desembaraco,Vencimento,
			Num_Nf,Order_by
		
		Order by Order_By




*/

































GO
