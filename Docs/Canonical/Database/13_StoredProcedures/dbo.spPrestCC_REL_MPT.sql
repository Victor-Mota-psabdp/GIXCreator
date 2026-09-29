SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--incluido um where q nao tinha em IO e IM - 22-07 - Cadu
-- era utilizada a spPrestCC_REL_Test
--incluido o and TCHB.Modal=left(fatura_pc,1) pq estava duplicando algumas taxas q tem E e I nesta tabela
create Procedure [dbo].[spPrestCC_REL_MPT]--'IMMPT201304001BRF','S'
		@Fatura_PC varchar(17),
		@Tipo	Varchar(1),
		@fatcod varchar(17)

as
	Declare @Cd_Pes Varchar(10)
	
	Set @CD_PES=(select cd_pes_Grupo from grupo where grupo=substring(@fatura_PC,3,3))

if @Tipo = 'F'
	Begin
		-- HEO (EXPORTACAO OUTROS)
		SELECT top 1
			Data_PC,fatDtVenc,Obs_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ ,Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,RUA,Numero,Cidade,UF,max(Numero_PO_HEO) Referencia_Cliente,DI_RE_PC,org.nome_local Origem, dst.nome_local Destino,hawb_HEO House,NULL CD_TP_TX,NULL NOME_TP_TX, NULL VLR_PC, TP_PGTO, Obs_heo OBS_HOU, CNS.Nome_Raz_Soc CNS, LDE.Nome_Local Local_Desemb,
			dbo.fBusca_Tarefa(HOU.Num_Proc_HEO,4) Dt_Desembaraco,Data_PC,fatDtVenc Vencimento, isnull(Ordem,99) Order_By
		FROM 
			FATURA_CHB FAT
			JOIN FATURA_CHB_ITEM ITM ON ITM.FATURA_CC=FAT.FATURA_PC
			JOIN PESSOA PP ON PP.CD_PES=CD_PES_PC 
			LEFT Join Endereco ED on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
			LEFT JOIN HOUSE_EXP_OUT HOU ON HOU.NUM_PROC_HEO=LEFT(FATURA_PC,16)
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
			FATURA_PC=@FATURA_PC --and imprime='S' and @Tipo='S')
			--or
			--(FATURA_PC=@FATURA_PC and @Tipo='C')

		GROUP BY
			HOU.Num_Proc_HEO, Data_pc,fatdtvenc,Obs_Pc,Obs_Heo,right(PP.Num_CPF_CNPJ,14),Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,hawb_HEO ,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, CNS.Nome_Raz_Soc, LDE.Nome_Local,
			Descricao,isnull(Ordem,99) 
		
		Union All

		SELECT top 1
			Data_PC,fatdtvenc,OBS_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ ,Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,RUA,Numero,Cidade,UF,max(Numero_PO_HEO) Referencia_Cliente,DI_RE_PC,org.nome_local Origem, dst.nome_local Destino,hawb_HEO House,NULL CD_TP_TX,NULL NOME_TP_TX, NULL VLR_PC, 'B', Obs_hEO OBS_HOU, CNS.Nome_Raz_Soc CNS, LDE.Nome_Local Local_Desemb,
			dbo.fBusca_Tarefa(HOU.Num_Proc_HEO,4) Dt_Desembaraco,Data_PC,fatDtVenc Vencimento,isnull(Ordem,99) Order_By
		FROM 
			FATURA_CHB FAT
			left Join Tipo_Taxa_PC_CHB TCHB on cd_pes_grupo=@cd_pes and TCHB.Modal=left(fatura_pc,1)
			Left JOIN FATURA_CHB_ITEM ITM ON ITM.FATURA_CC=FAT.FATURA_PC and TCHB.cd_Tp_Tx=ITM.cd_tp_Tx
			JOIN PESSOA PP ON PP.CD_PES=CD_PES_PC
			LEFT Join Endereco ED on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
			LEFT JOIN HOUSE_EXP_OUT HOU ON HOU.NUM_PROC_HEO=LEFT(FATURA_PC,16)
			LEft join Tipo_Taxa TT on TT.cd_tp_Tx=itm.cd_tp_Tx
			LEft Join PO_HEO PO on lefT(fat.fatura_pc,16)=po.num_proC_hEO  AND ID_DC = 1
			Join Localidade Org on Org.cd_local=cd_org_hEO
			Join Localidade dst on dst.cd_local=cd_dst_hEO
			left join Pessoa CNS on CNS.cd_pes = HOU.cd_Export_HEO
			Left Join Campo_Processo CP on CP.Num_Proc=left(@Fatura_PC,16) and Id_Campo=25
			Left Join Localidade LDE on LDE.cd_local=CP.Campo_Dados
			Left Join Fatura on fatcod=fatura_pc

		WHERE 
			(cd_pes_grupo is not null and nome_tp_Tx is null) and FATURA_PC=@FATURA_PC 
		group by 
			HOU.Num_Proc_HEO,Data_PC,fatdtvenc,obs_PC,obs_hEO,right(pp.Num_CPF_CNPJ,14), Fatura_PC,pp.Apelido,pp.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,hawb_hEO ,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, CNS.Nome_Raz_Soc, LDE.Nome_Local,isnull(Ordem,99) ,DESCRICAO,TCHB.cd_Tp_Tx	

	--HEM (Exportação Maritima)

	union all


		SELECT top 1
			Data_PC,fatDtVenc,Obs_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ ,Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,RUA,Numero,Cidade,UF,max(Numero_PO_HEM) Referencia_Cliente,DI_RE_PC,org.nome_local Origem, dst.nome_local Destino,hawb_HEM House,NULL CD_TP_TX,NULL NOME_TP_TX, NULL VLR_PC, TP_PGTO, Obs_HEM OBS_HOU, CNS.Nome_Raz_Soc CNS, LDE.Nome_Local Local_Desemb,
			dbo.fBusca_Tarefa(HOU.Num_Proc_HEM,4) Dt_Desembaraco,Data_PC,fatDtVenc Vencimento, isnull(Ordem,99) Order_By
		FROM 
			FATURA_CHB FAT
			JOIN FATURA_CHB_ITEM ITM ON ITM.FATURA_CC=FAT.FATURA_PC
			JOIN PESSOA PP ON PP.CD_PES=CD_PES_PC 
			LEFT Join Endereco ED on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
			LEFT JOIN HOUSE_EXP_Mar HOU ON HOU.NUM_PROC_HEM=LEFT(FATURA_PC,16)
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
			FATURA_PC=@FATURA_PC --and imprime='S' and @Tipo='S')
			--or
			--(FATURA_PC=@FATURA_PC and @Tipo='C')
		GROUP BY
			HOU.Num_Proc_HEM, Data_pc,fatdtvenc,Obs_Pc,Obs_HEM,right(PP.Num_CPF_CNPJ,14),Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,hawb_HEM ,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, CNS.Nome_Raz_Soc, LDE.Nome_Local,
			Descricao,isnull(Ordem,99)
		
		Union All

		SELECT top 1
			Data_PC,fatdtvenc,OBS_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ ,Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,RUA,Numero,Cidade,UF,max(Numero_PO_HEM) Referencia_Cliente,DI_RE_PC,org.nome_local Origem, dst.nome_local Destino,hawb_HEM House,NULL CD_TP_TX,NULL NOME_TP_TX, NULL VLR_PC, 'B', Obs_HEM OBS_HOU, CNS.Nome_Raz_Soc CNS, LDE.Nome_Local Local_Desemb,
			dbo.fBusca_Tarefa(HOU.Num_Proc_HEM,4) Dt_Desembaraco,Data_PC,fatDtVenc Vencimento,isnull(Ordem,99) Order_By
		FROM 
			FATURA_CHB FAT
			left Join Tipo_Taxa_PC_CHB TCHB on cd_pes_grupo=@cd_pes and TCHB.Modal=left(fatura_pc,1)
			Left JOIN FATURA_CHB_ITEM ITM ON ITM.FATURA_CC=FAT.FATURA_PC and TCHB.cd_Tp_Tx=ITM.cd_tp_Tx
			JOIN PESSOA PP ON PP.CD_PES=CD_PES_PC
			LEFT Join Endereco ED on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
			LEFT JOIN HOUSE_EXP_Mar HOU ON HOU.NUM_PROC_HEM=LEFT(FATURA_PC,16)
			LEft join Tipo_Taxa TT on TT.cd_tp_Tx=itm.cd_tp_Tx
			LEft Join PO_HEM PO on lefT(fat.fatura_pc,16)=po.num_proC_HEM  AND ID_DC = 1
			Join Localidade Org on Org.cd_local=cd_org_HEM
			Join Localidade dst on dst.cd_local=cd_dst_HEM
			left join Pessoa CNS on CNS.cd_pes = HOU.cd_Export_HEM
			Left Join Campo_Processo CP on CP.Num_Proc=left(@Fatura_PC,16) and Id_Campo=25
			Left Join Localidade LDE on LDE.cd_local=CP.Campo_Dados
			Left Join Fatura on fatcod=fatura_pc

		WHERE 
			(cd_pes_grupo is not null and nome_tp_Tx is null) and FATURA_PC=@FATURA_PC 
		group by 
			HOU.Num_Proc_HEM,Data_PC,fatdtvenc,obs_PC,obs_HEM,right(pp.Num_CPF_CNPJ,14), Fatura_PC,pp.Apelido,pp.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,hawb_HEM ,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, CNS.Nome_Raz_Soc, LDE.Nome_Local,isnull(Ordem,99) ,DESCRICAO,TCHB.cd_Tp_Tx	


	UNION ALL
	--HEA (EXPORTAÇÃO AÉREA)

		SELECT top 1
			Data_PC,fatDtVenc,Obs_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ ,Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,RUA,Numero,Cidade,UF,max(Numero_PO_HEA) Referencia_Cliente,DI_RE_PC,org.nome_local Origem, dst.nome_local Destino,hawb_HEA House,NULL CD_TP_TX,NULL NOME_TP_TX, NULL VLR_PC, TP_PGTO, Obs_HEA OBS_HOU, CNS.Nome_Raz_Soc CNS, LDE.Nome_Local Local_Desemb,
			dbo.fBusca_Tarefa(HOU.Num_Proc_HEA,4) Dt_Desembaraco,Data_PC,fatDtVenc Vencimento, isnull(Ordem,99) Order_By
		FROM 
			FATURA_CHB FAT
			JOIN FATURA_CHB_ITEM ITM ON ITM.FATURA_CC=FAT.FATURA_PC
			JOIN PESSOA PP ON PP.CD_PES=CD_PES_PC 
			LEFT Join Endereco ED on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
			LEFT JOIN HOUSE_EXP_Aer HOU ON HOU.NUM_PROC_HEA=LEFT(FATURA_PC,16)
			join Tipo_Taxa TT on TT.cd_tp_Tx=itm.cd_tp_Tx
			LEft Join PO_HEA PO on lefT(fat.fatura_pc,16)=po.num_proC_HEA AND ID_DC = 1
			Join Localidade Org on Org.cd_local=cd_org_HEA
			Join Localidade dst on dst.cd_local=cd_dst_HEA
			left join Pessoa CNS on CNS.cd_pes = HOU.cd_export_HEA
			Left Join Campo_Processo CP on CP.Num_Proc=left(@Fatura_PC,16) and Id_Campo=25
			Left Join Localidade LDE on LDE.cd_local=CP.Campo_Dados
			Left Join Fatura on fatcod=fatura_pc
			Left Join Tipo_Taxa_PC_CHB TCHB on TCHB.cd_tp_tx=TT.cd_tp_tx and cd_pes_grupo=@cd_pes
		WHERE 
			FATURA_PC=@FATURA_PC-- and imprime='S' and @Tipo='S')
			--or
			--(FATURA_PC=@FATURA_PC and @Tipo='C')
		GROUP BY
			HOU.Num_Proc_HEA, Data_pc,fatdtvenc,Obs_Pc,Obs_HEA,right(PP.Num_CPF_CNPJ,14),Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,hawb_HEA ,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, CNS.Nome_Raz_Soc, LDE.Nome_Local,
			Descricao,isnull(Ordem,99) 
		
		Union All

		SELECT 
			Data_PC,fatdtvenc,OBS_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ ,Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,RUA,Numero,Cidade,UF,max(Numero_PO_HEA) Referencia_Cliente,DI_RE_PC,org.nome_local Origem, dst.nome_local Destino,hawb_HEA House,NULL CD_TP_TX,NULL NOME_TP_TX, NULL VLR_PC, 'B', Obs_HEA OBS_HOU, CNS.Nome_Raz_Soc CNS, LDE.Nome_Local Local_Desemb,
			dbo.fBusca_Tarefa(HOU.Num_Proc_HEA,4) Dt_Desembaraco,Data_PC,fatDtVenc Vencimento,isnull(Ordem,99) Order_By
		FROM 
			FATURA_CHB FAT
			left Join Tipo_Taxa_PC_CHB TCHB on cd_pes_grupo=@cd_pes and TCHB.Modal=left(fatura_pc,1)
			Left JOIN FATURA_CHB_ITEM ITM ON ITM.FATURA_CC=FAT.FATURA_PC and TCHB.cd_Tp_Tx=ITM.cd_tp_Tx
			JOIN PESSOA PP ON PP.CD_PES=CD_PES_PC
			LEFT Join Endereco ED on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
			LEFT JOIN HOUSE_EXP_Aer HOU ON HOU.NUM_PROC_HEA=LEFT(FATURA_PC,16)
			LEft join Tipo_Taxa TT on TT.cd_tp_Tx=itm.cd_tp_Tx
			LEft Join PO_HEA PO on lefT(fat.fatura_pc,16)=po.num_proC_HEA  AND ID_DC = 1
			Join Localidade Org on Org.cd_local=cd_org_HEA
			Join Localidade dst on dst.cd_local=cd_dst_HEA
			left join Pessoa CNS on CNS.cd_pes = HOU.cd_Export_HEA
			Left Join Campo_Processo CP on CP.Num_Proc=left(@Fatura_PC,16) and Id_Campo=25
			Left Join Localidade LDE on LDE.cd_local=CP.Campo_Dados
			Left Join Fatura on fatcod=fatura_pc

		WHERE 
			(cd_pes_grupo is not null and nome_tp_Tx is null) and FATURA_PC=@FATURA_PC 
		group by 
			HOU.Num_Proc_HEA,Data_PC,fatdtvenc,obs_PC,obs_HEA,right(pp.Num_CPF_CNPJ,14), Fatura_PC,pp.Apelido,pp.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,hawb_HEA ,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, CNS.Nome_Raz_Soc, LDE.Nome_Local,isnull(Ordem,99) ,DESCRICAO,TCHB.cd_Tp_Tx	


	union all

	-- HIO (IMPORTAÇÃO OUTROS)
		SELECT top 1
			Data_PC,fatDtVenc,Obs_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ ,Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,RUA,Numero,Cidade,UF,max(Numero_PO_HIO) Referencia_Cliente,DI_RE_PC,org.nome_local Origem, dst.nome_local Destino,hawb_HIO House,NULL CD_TP_TX,NULL NOME_TP_TX, NULL VLR_PC, TP_PGTO, Obs_HIO OBS_HOU, CNS.Nome_Raz_Soc CNS, LDE.Nome_Local Local_Desemb,
			dbo.fBusca_Tarefa(HOU.Num_Proc_HIO,4) Dt_Desembaraco,Data_PC,fatDtVenc Vencimento, isnull(Ordem,99) Order_By
		FROM 
			FATURA_CHB FAT
			JOIN FATURA_CHB_ITEM ITM ON ITM.FATURA_CC=FAT.FATURA_PC
			JOIN PESSOA PP ON PP.CD_PES=CD_PES_PC 
			LEFT Join Endereco ED on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
			LEFT JOIN HOUSE_IMP_OUT HOU ON HOU.NUM_PROC_HIO=LEFT(FATURA_PC,16)
			join Tipo_Taxa TT on TT.cd_tp_Tx=itm.cd_tp_Tx
			LEft Join PO_HIO PO on lefT(fat.fatura_pc,16)=po.num_proC_HIO AND ID_DC = 1
			Join Localidade Org on Org.cd_local=cd_org_HIO
			Join Localidade dst on dst.cd_local=cd_dst_HIO
			left join Pessoa CNS on CNS.cd_pes = HOU.CD_CONSIG_HIO
			Left Join Campo_Processo CP on CP.Num_Proc=left(@Fatura_PC,16) and Id_Campo=25
			Left Join Localidade LDE on LDE.cd_local=CP.Campo_Dados
			Left Join Fatura on fatcod=fatura_pc
			Left Join Tipo_Taxa_PC_CHB TCHB on TCHB.cd_tp_tx=TT.cd_tp_tx and cd_pes_grupo=@cd_pes
		WHERE 
			FATURA_PC=@FATURA_PC --and imprime='S' and @Tipo='S')
			--or
			--(FATURA_PC=@FATURA_PC and @Tipo='C')
		GROUP BY
			HOU.Num_Proc_HIO, Data_pc,fatdtvenc,Obs_Pc,Obs_HIO,right(PP.Num_CPF_CNPJ,14),Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,hawb_HIO ,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, CNS.Nome_Raz_Soc, LDE.Nome_Local,
			Descricao,isnull(Ordem,99) 
		
		Union All

		SELECT 
			Data_PC,fatdtvenc,OBS_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ ,Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,RUA,Numero,Cidade,UF,max(Numero_PO_HIO) Referencia_Cliente,DI_RE_PC,org.nome_local Origem, dst.nome_local Destino,hawb_HIO House,NULL CD_TP_TX,NULL NOME_TP_TX, NULL VLR_PC, 'B', Obs_HIO OBS_HOU, CNS.Nome_Raz_Soc CNS, LDE.Nome_Local Local_Desemb,
			dbo.fBusca_Tarefa(HOU.Num_Proc_HIO,4) Dt_Desembaraco,Data_PC,fatDtVenc Vencimento,isnull(Ordem,99) Order_By
		FROM 
			FATURA_CHB FAT
			left Join Tipo_Taxa_PC_CHB TCHB on cd_pes_grupo=@cd_pes and TCHB.Modal=left(fatura_pc,1)
			Left JOIN FATURA_CHB_ITEM ITM ON ITM.FATURA_CC=FAT.FATURA_PC and TCHB.cd_Tp_Tx=ITM.cd_tp_Tx
			JOIN PESSOA PP ON PP.CD_PES=CD_PES_PC
			LEFT Join Endereco ED on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
			LEFT JOIN HOUSE_IMP_OUT HOU ON HOU.NUM_PROC_HIO=LEFT(FATURA_PC,16)
			LEft join Tipo_Taxa TT on TT.cd_tp_Tx=itm.cd_tp_Tx
			LEft Join PO_HIO PO on lefT(fat.fatura_pc,16)=po.num_proC_HIO  AND ID_DC = 1
			Join Localidade Org on Org.cd_local=cd_org_HIO
			Join Localidade dst on dst.cd_local=cd_dst_HIO
			left join Pessoa CNS on CNS.cd_pes = HOU.CD_CONSIG_HIO
			Left Join Campo_Processo CP on CP.Num_Proc=left(@Fatura_PC,16) and Id_Campo=25
			Left Join Localidade LDE on LDE.cd_local=CP.Campo_Dados
			Left Join Fatura on fatcod=fatura_pc

		WHERE 
			FATURA_PC=@FATURA_PC --and imprime='S' and @Tipo='S')
			--or
			--(FATURA_PC=@FATURA_PC and @Tipo='C')
		group by 
			HOU.Num_Proc_HIO,Data_PC,fatdtvenc,obs_PC,obs_HIO,right(pp.Num_CPF_CNPJ,14), Fatura_PC,pp.Apelido,pp.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,hawb_HIO ,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, CNS.Nome_Raz_Soc, LDE.Nome_Local,isnull(Ordem,99) ,DESCRICAO,TCHB.cd_Tp_Tx	

	--HIM (IMPORTAÇÃO MARITIMA)

	union all


		SELECT top 1
			Data_PC,fatDtVenc,Obs_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ ,Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,RUA,Numero,Cidade,UF,max(Numero_PO_HIM) Referencia_Cliente,DI_RE_PC,org.nome_local Origem, dst.nome_local Destino,hawb_HIM House,NULL CD_TP_TX,NULL NOME_TP_TX, NULL VLR_PC, TP_PGTO, Obs_HIM OBS_HOU, CNS.Nome_Raz_Soc CNS, LDE.Nome_Local Local_Desemb,
			dbo.fBusca_Tarefa(HOU.Num_Proc_HIM,4) Dt_Desembaraco,Data_PC,fatDtVenc Vencimento, isnull(Ordem,99) Order_By
		FROM 
			FATURA_CHB FAT
			JOIN FATURA_CHB_ITEM ITM ON ITM.FATURA_CC=FAT.FATURA_PC
			JOIN PESSOA PP ON PP.CD_PES=CD_PES_PC 
			LEFT Join Endereco ED on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
			LEFT JOIN HOUSE_IMP_Mar HOU ON HOU.NUM_PROC_HIM=LEFT(FATURA_PC,16)
			join Tipo_Taxa TT on TT.cd_tp_Tx=itm.cd_tp_Tx
			LEft Join PO_HIM PO on lefT(fat.fatura_pc,16)=po.num_proC_HIM AND ID_DC = 1
			Join Localidade Org on Org.cd_local=cd_org_HIM
			Join Localidade dst on dst.cd_local=cd_dst_HIM
			left join Pessoa CNS on CNS.cd_pes = HOU.CD_CONSIG_HIM
			Left Join Campo_Processo CP on CP.Num_Proc=left(@Fatura_PC,16) and Id_Campo=25
			Left Join Localidade LDE on LDE.cd_local=CP.Campo_Dados
			Left Join Fatura on fatcod=fatura_pc
			Left Join Tipo_Taxa_PC_CHB TCHB on TCHB.cd_tp_tx=TT.cd_tp_tx and cd_pes_grupo=@cd_pes
		WHERE 
			FATURA_PC=@FATURA_PC-- and imprime='S' and @Tipo='S')
			--or
			--(FATURA_PC=@FATURA_PC and @Tipo='C')
		GROUP BY
			HOU.Num_Proc_HIM, Data_pc,fatdtvenc,Obs_Pc,Obs_HIM,right(PP.Num_CPF_CNPJ,14),Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,hawb_HIM ,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, CNS.Nome_Raz_Soc, LDE.Nome_Local,
			Descricao,isnull(Ordem,99) 
		
		Union All

		SELECT top 1
			Data_PC,fatdtvenc,OBS_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ ,Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,RUA,Numero,Cidade,UF,max(Numero_PO_HIM) Referencia_Cliente,DI_RE_PC,org.nome_local Origem, dst.nome_local Destino,hawb_HIM House,NULL CD_TP_TX,NULL NOME_TP_TX, NULL VLR_PC, 'B', Obs_HIM OBS_HOU, CNS.Nome_Raz_Soc CNS, LDE.Nome_Local Local_Desemb,
			dbo.fBusca_Tarefa(HOU.Num_Proc_HIM,4) Dt_Desembaraco,Data_PC,fatDtVenc Vencimento,isnull(Ordem,99) Order_By
		FROM 
			FATURA_CHB FAT
			left Join Tipo_Taxa_PC_CHB TCHB on cd_pes_grupo=@cd_pes and TCHB.Modal=left(fatura_pc,1)
			Left JOIN FATURA_CHB_ITEM ITM ON ITM.FATURA_CC=FAT.FATURA_PC and TCHB.cd_Tp_Tx=ITM.cd_tp_Tx
			JOIN PESSOA PP ON PP.CD_PES=CD_PES_PC
			LEFT Join Endereco ED on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
			LEFT JOIN HOUSE_IMP_Mar HOU ON HOU.NUM_PROC_HIM=LEFT(FATURA_PC,16)
			LEft join Tipo_Taxa TT on TT.cd_tp_Tx=itm.cd_tp_Tx
			LEft Join PO_HIM PO on lefT(fat.fatura_pc,16)=po.num_proC_HIM  AND ID_DC = 1
			Join Localidade Org on Org.cd_local=cd_org_HIM
			Join Localidade dst on dst.cd_local=cd_dst_HIM
			left join Pessoa CNS on CNS.cd_pes = HOU.CD_CONSIG_HIM
			Left Join Campo_Processo CP on CP.Num_Proc=left(@Fatura_PC,16) and Id_Campo=25
			Left Join Localidade LDE on LDE.cd_local=CP.Campo_Dados
			Left Join Fatura on fatcod=fatura_pc

		WHERE 
			FATURA_PC=@FATURA_PC --and imprime='S' and @Tipo='S')
			--or
			--(FATURA_PC=@FATURA_PC and @Tipo='C')
		group by 
			HOU.Num_Proc_HIM,Data_PC,fatdtvenc,obs_PC,obs_HIM,right(pp.Num_CPF_CNPJ,14), Fatura_PC,pp.Apelido,pp.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,hawb_HIM ,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, CNS.Nome_Raz_Soc, LDE.Nome_Local,isnull(Ordem,99) ,DESCRICAO,TCHB.cd_Tp_Tx	


	UNION ALL

	--HIA (IMPORTAÇÃO AÉREA)

		SELECT top 1
			Data_PC,fatDtVenc,Obs_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ ,Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,RUA,Numero,Cidade,UF,max(Numero_PO_HIA) Referencia_Cliente,DI_RE_PC,org.nome_local Origem, dst.nome_local Destino,hawb_HIA House,NULL CD_TP_TX,NULL NOME_TP_TX, NULL VLR_PC, TP_PGTO, Obs_HIA OBS_HOU, CNS.Nome_Raz_Soc CNS, LDE.Nome_Local Local_Desemb,
			dbo.fBusca_Tarefa(HOU.Num_Proc_HIA,4) Dt_Desembaraco,Data_PC,fatDtVenc Vencimento, isnull(Ordem,99) Order_By
		FROM 
			FATURA_CHB FAT
			JOIN FATURA_CHB_ITEM ITM ON ITM.FATURA_CC=FAT.FATURA_PC
			JOIN PESSOA PP ON PP.CD_PES=CD_PES_PC 
			LEFT Join Endereco ED on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
			LEFT JOIN HOUSE_IMP_Aer HOU ON HOU.NUM_PROC_HIA=LEFT(FATURA_PC,16)
			join Tipo_Taxa TT on TT.cd_tp_Tx=itm.cd_tp_Tx
			LEft Join PO_HIA PO on lefT(fat.fatura_pc,16)=po.num_proC_HIA AND ID_DC = 1
			Join Localidade Org on Org.cd_local=cd_org_HIA
			Join Localidade dst on dst.cd_local=cd_dst_HIA
			left join Pessoa CNS on CNS.cd_pes = HOU.CD_CONSIG_HIA
			Left Join Campo_Processo CP on CP.Num_Proc=left(@Fatura_PC,16) and Id_Campo=25
			Left Join Localidade LDE on LDE.cd_local=CP.Campo_Dados
			Left Join Fatura on fatcod=fatura_pc
			Left Join Tipo_Taxa_PC_CHB TCHB on TCHB.cd_tp_tx=TT.cd_tp_tx and cd_pes_grupo=@cd_pes
		WHERE 
			FATURA_PC=@FATURA_PC --and imprime='S' and @Tipo='S')
			--or
			--(FATURA_PC=@FATURA_PC and @Tipo='C')
		GROUP BY
			HOU.Num_Proc_HIA, Data_pc,fatdtvenc,Obs_Pc,Obs_HIA,right(PP.Num_CPF_CNPJ,14),Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,hawb_HIA ,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, CNS.Nome_Raz_Soc, LDE.Nome_Local,
			Descricao,isnull(Ordem,99) 
		
		Union All

		SELECT top 1
			Data_PC,fatdtvenc,OBS_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ ,Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,RUA,Numero,Cidade,UF,max(Numero_PO_HIA) Referencia_Cliente,DI_RE_PC,org.nome_local Origem, dst.nome_local Destino,hawb_HIA House,NULL CD_TP_TX,NULL NOME_TP_TX, NULL VLR_PC, 'B', Obs_HIA OBS_HOU, CNS.Nome_Raz_Soc CNS, LDE.Nome_Local Local_Desemb,
			dbo.fBusca_Tarefa(HOU.Num_Proc_HIA,4) Dt_Desembaraco,Data_PC,fatDtVenc Vencimento,isnull(Ordem,99) Order_By
		FROM 
			FATURA_CHB FAT
			left Join Tipo_Taxa_PC_CHB TCHB on cd_pes_grupo=@cd_pes and TCHB.Modal=left(fatura_pc,1)
			Left JOIN FATURA_CHB_ITEM ITM ON ITM.FATURA_CC=FAT.FATURA_PC and TCHB.cd_Tp_Tx=ITM.cd_tp_Tx
			JOIN PESSOA PP ON PP.CD_PES=CD_PES_PC
			LEFT Join Endereco ED on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
			LEFT JOIN HOUSE_IMP_Aer HOU ON HOU.NUM_PROC_HIA=LEFT(FATURA_PC,16)
			LEft join Tipo_Taxa TT on TT.cd_tp_Tx=itm.cd_tp_Tx
			LEft Join PO_HIA PO on lefT(fat.fatura_pc,16)=po.num_proC_HIA  AND ID_DC = 1
			Join Localidade Org on Org.cd_local=cd_org_HIA
			Join Localidade dst on dst.cd_local=cd_dst_HIA
			left join Pessoa CNS on CNS.cd_pes = HOU.CD_CONSIG_HIA
			Left Join Campo_Processo CP on CP.Num_Proc=left(@Fatura_PC,16) and Id_Campo=25
			Left Join Localidade LDE on LDE.cd_local=CP.Campo_Dados
			Left Join Fatura on fatcod=fatura_pc

		WHERE 
			(cd_pes_grupo is not null and nome_tp_Tx is null) and FATURA_PC=@FATURA_PC 
		group by 
			HOU.Num_Proc_HIA,Data_PC,fatdtvenc,obs_PC,obs_HIA,right(pp.Num_CPF_CNPJ,14), Fatura_PC,pp.Apelido,pp.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,hawb_HIA ,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, CNS.Nome_Raz_Soc, LDE.Nome_Local,isnull(Ordem,99) ,DESCRICAO,TCHB.cd_Tp_Tx	



	Order by order_by
	End
else
	Begin
	-- HEO (EXPORTACAO OUTROS)
		SELECT 
			Data_PC,F.fatDtVenc,Obs_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ ,Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,RUA,Numero,Cidade,UF,max(Numero_PO_HEO) Referencia_Cliente,DI_RE_PC,org.nome_local Origem, dst.nome_local Destino,hawb_HEO House,IFT.CD_TP_TX,isnull(descricao,NOME_TP_TX) + ' ('+ @fatcod + ')' Nome_Tp_Tx,IFT.Vlr_RS VLR_PC,  'B'  TP_PGTO, Obs_HEO OBS_HOU, CNS.Nome_Raz_Soc CNS, LDE.Nome_Local Local_Desemb,
			dbo.fBusca_Tarefa(HOU.Num_Proc_HEO,4) Dt_Desembaraco,Data_PC,F.fatDtVenc Vencimento, isnull(Ordem,99) Order_By
		FROM 
			FATURA_CHB FAT
			JOIN FATURA_CHB_ITEM ITM ON ITM.FATURA_CC=FAT.FATURA_PC
			Join Fatura FT with(nolock)on FT.fatcod=@fatcod
			Join Item_Fat IFT with(nolock)on FT.fatcod = IFT.FatCod
			JOIN PESSOA PP ON PP.CD_PES=CD_PES_PC 
			LEFT Join Endereco ED on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
			LEFT JOIN HOUSE_EXP_OUT HOU ON HOU.NUM_PROC_HEO=LEFT(FATURA_PC,16)
			join Tipo_Taxa TT on TT.cd_tp_Tx=IFT.cd_tp_Tx
			LEft Join PO_HEO PO on lefT(fat.fatura_pc,16)=po.num_proC_HEO AND ID_DC = 1
			Join Localidade Org on Org.cd_local=cd_org_HEO
			Join Localidade dst on dst.cd_local=cd_dst_HEO
			left join Pessoa CNS on CNS.cd_pes = HOU.CD_CONSIG_HEO
			Left Join Campo_Processo CP on CP.Num_Proc=left(@Fatura_PC,16) and Id_Campo=25
			Left Join Localidade LDE on LDE.cd_local=CP.Campo_Dados
			Left Join Fatura F on F.fatcod=fatura_pc
			Left Join Tipo_Taxa_PC_CHB TCHB on TCHB.cd_tp_tx=TT.cd_tp_tx and cd_pes_grupo=@cd_pes and TCHB.Modal=left(fatura_pc,1)
		WHERE 
			FATURA_PC=@FATURA_PC and @Tipo='S'
		GROUP BY
			HOU.Num_Proc_HEO, Data_pc,F.fatdtvenc,Obs_Pc,Obs_HEO,right(PP.Num_CPF_CNPJ,14),Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,hawb_HEO ,IFT.CD_TP_TX,NOME_TP_TX,IFT.Vlr_RS, TP_PGTO, CNS.Nome_Raz_Soc, LDE.Nome_Local,
			Descricao,isnull(Ordem,99) 
	union all
		SELECT 
			Data_PC,fatDtVenc,Obs_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ ,Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,RUA,Numero,Cidade,UF,max(Numero_PO_HEO) Referencia_Cliente,DI_RE_PC,org.nome_local Origem, dst.nome_local Destino,hawb_HEO House,ITM.CD_TP_TX,isnull(descricao,NOME_TP_TX) Nome_Tp_Tx,VLR_PC, TP_PGTO, Obs_heo OBS_HOU, CNS.Nome_Raz_Soc CNS, LDE.Nome_Local Local_Desemb,
			dbo.fBusca_Tarefa(HOU.Num_Proc_HEO,4) Dt_Desembaraco,Data_PC,fatDtVenc Vencimento, isnull(Ordem,99) Order_By
		FROM 
			FATURA_CHB FAT
			JOIN FATURA_CHB_ITEM ITM ON ITM.FATURA_CC=FAT.FATURA_PC
			JOIN PESSOA PP ON PP.CD_PES=CD_PES_PC 
			LEFT Join Endereco ED on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
			LEFT JOIN HOUSE_EXP_OUT HOU ON HOU.NUM_PROC_HEO=LEFT(FATURA_PC,16)
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
			(FATURA_PC=@FATURA_PC and imprime='S' and @Tipo='S')
			or
			(FATURA_PC=@FATURA_PC and @Tipo='C')

		GROUP BY
			HOU.Num_Proc_HEO, Data_pc,fatdtvenc,Obs_Pc,Obs_Heo,right(PP.Num_CPF_CNPJ,14),Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,hawb_HEO ,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, CNS.Nome_Raz_Soc, LDE.Nome_Local,
			Descricao,isnull(Ordem,99) 
		
		Union All

		SELECT 
			Data_PC,fatdtvenc,OBS_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ ,Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,RUA,Numero,Cidade,UF,max(Numero_PO_HEO) Referencia_Cliente,DI_RE_PC,org.nome_local Origem, dst.nome_local Destino,hawb_HEO House,TCHB.CD_TP_TX,isnull(descricao,NOME_TP_TX) Nome_tp_Tx,Isnull(VLR_PC,0), 'B', Obs_hEO OBS_HOU, CNS.Nome_Raz_Soc CNS, LDE.Nome_Local Local_Desemb,
			dbo.fBusca_Tarefa(HOU.Num_Proc_HEO,4) Dt_Desembaraco,Data_PC,fatDtVenc Vencimento,isnull(Ordem,99) Order_By
		FROM 
			FATURA_CHB FAT
			left Join Tipo_Taxa_PC_CHB TCHB on cd_pes_grupo=@cd_pes and TCHB.Modal=left(fatura_pc,1)
			Left JOIN FATURA_CHB_ITEM ITM ON ITM.FATURA_CC=FAT.FATURA_PC and TCHB.cd_Tp_Tx=ITM.cd_tp_Tx
			JOIN PESSOA PP ON PP.CD_PES=CD_PES_PC
			LEFT Join Endereco ED on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
			LEFT JOIN HOUSE_EXP_OUT HOU ON HOU.NUM_PROC_HEO=LEFT(FATURA_PC,16)
			LEft join Tipo_Taxa TT on TT.cd_tp_Tx=itm.cd_tp_Tx
			LEft Join PO_HEO PO on lefT(fat.fatura_pc,16)=po.num_proC_hEO  AND ID_DC = 1
			Join Localidade Org on Org.cd_local=cd_org_hEO
			Join Localidade dst on dst.cd_local=cd_dst_hEO
			left join Pessoa CNS on CNS.cd_pes = HOU.cd_Export_HEO
			Left Join Campo_Processo CP on CP.Num_Proc=left(@Fatura_PC,16) and Id_Campo=25
			Left Join Localidade LDE on LDE.cd_local=CP.Campo_Dados
			Left Join Fatura on fatcod=fatura_pc

		WHERE 
			(cd_pes_grupo is not null and nome_tp_Tx is null) and FATURA_PC=@FATURA_PC 
		group by 
			HOU.Num_Proc_HEO,Data_PC,fatdtvenc,obs_PC,obs_hEO,right(pp.Num_CPF_CNPJ,14), Fatura_PC,pp.Apelido,pp.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,hawb_hEO ,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, CNS.Nome_Raz_Soc, LDE.Nome_Local,isnull(Ordem,99) ,DESCRICAO,TCHB.cd_Tp_Tx	

	--HEM (Exportação Maritima)

	union all


		SELECT 
			Data_PC,F.fatDtVenc,Obs_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ ,Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,RUA,Numero,Cidade,UF,max(Numero_PO_HEM) Referencia_Cliente,DI_RE_PC,org.nome_local Origem, dst.nome_local Destino,hawb_HEM House,IFT.CD_TP_TX,isnull(descricao,NOME_TP_TX) + ' ('+ @fatcod + ')' Nome_Tp_Tx,IFT.Vlr_RS VLR_PC,  'B'  TP_PGTO, Obs_HEM OBS_HOU, CNS.Nome_Raz_Soc CNS, LDE.Nome_Local Local_Desemb,
			dbo.fBusca_Tarefa(HOU.Num_Proc_HEM,4) Dt_Desembaraco,Data_PC,F.fatDtVenc Vencimento, isnull(Ordem,99) Order_By
		FROM 
			FATURA_CHB FAT
			JOIN FATURA_CHB_ITEM ITM ON ITM.FATURA_CC=FAT.FATURA_PC
			Join Fatura FT with(nolock)on FT.fatcod=@fatcod
			Join Item_Fat IFT with(nolock)on FT.fatcod = IFT.FatCod
			JOIN PESSOA PP ON PP.CD_PES=CD_PES_PC 
			LEFT Join Endereco ED on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
			LEFT JOIN HOUSE_EXP_MAR HOU ON HOU.NUM_PROC_HEM=LEFT(FATURA_PC,16)
			join Tipo_Taxa TT on TT.cd_tp_Tx=IFT.cd_tp_Tx
			LEft Join PO_HEM PO on lefT(fat.fatura_pc,16)=po.num_proC_HEM AND ID_DC = 1
			Join Localidade Org on Org.cd_local=cd_org_HEM
			Join Localidade dst on dst.cd_local=cd_dst_HEM
			left join Pessoa CNS on CNS.cd_pes = HOU.CD_CONSIG_HEM
			Left Join Campo_Processo CP on CP.Num_Proc=left(@Fatura_PC,16) and Id_Campo=25
			Left Join Localidade LDE on LDE.cd_local=CP.Campo_Dados
			Left Join Fatura F on F.fatcod=fatura_pc
			Left Join Tipo_Taxa_PC_CHB TCHB on TCHB.cd_tp_tx=TT.cd_tp_tx and cd_pes_grupo=@cd_pes and TCHB.Modal=left(fatura_pc,1)
		WHERE 
			FATURA_PC=@FATURA_PC and @Tipo='S'
		GROUP BY
			HOU.Num_Proc_HEM, Data_pc,F.fatdtvenc,Obs_Pc,Obs_HEM,right(PP.Num_CPF_CNPJ,14),Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,hawb_HEM ,IFT.CD_TP_TX,NOME_TP_TX,IFT.Vlr_RS, TP_PGTO, CNS.Nome_Raz_Soc, LDE.Nome_Local,
			Descricao,isnull(Ordem,99) 
	union all

		SELECT 
			Data_PC,fatDtVenc,Obs_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ ,Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,RUA,Numero,Cidade,UF,max(Numero_PO_HEM) Referencia_Cliente,DI_RE_PC,org.nome_local Origem, dst.nome_local Destino,hawb_HEM House,ITM.CD_TP_TX,isnull(descricao,NOME_TP_TX) Nome_Tp_Tx,VLR_PC, TP_PGTO, Obs_HEM OBS_HOU, CNS.Nome_Raz_Soc CNS, LDE.Nome_Local Local_Desemb,
			dbo.fBusca_Tarefa(HOU.Num_Proc_HEM,4) Dt_Desembaraco,Data_PC,fatDtVenc Vencimento, isnull(Ordem,99) Order_By
		FROM 
			FATURA_CHB FAT
			JOIN FATURA_CHB_ITEM ITM ON ITM.FATURA_CC=FAT.FATURA_PC
			JOIN PESSOA PP ON PP.CD_PES=CD_PES_PC 
			LEFT Join Endereco ED on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
			LEFT JOIN HOUSE_EXP_Mar HOU ON HOU.NUM_PROC_HEM=LEFT(FATURA_PC,16)
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
			(FATURA_PC=@FATURA_PC and imprime='S' and @Tipo='S')
			or
			(FATURA_PC=@FATURA_PC and @Tipo='C')
		GROUP BY
			HOU.Num_Proc_HEM, Data_pc,fatdtvenc,Obs_Pc,Obs_HEM,right(PP.Num_CPF_CNPJ,14),Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,hawb_HEM ,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, CNS.Nome_Raz_Soc, LDE.Nome_Local,
			Descricao,isnull(Ordem,99)
		
		Union All

		SELECT 
			Data_PC,fatdtvenc,OBS_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ ,Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,RUA,Numero,Cidade,UF,max(Numero_PO_HEM) Referencia_Cliente,DI_RE_PC,org.nome_local Origem, dst.nome_local Destino,hawb_HEM House,TCHB.CD_TP_TX,isnull(descricao,NOME_TP_TX) Nome_tp_Tx,Isnull(VLR_PC,0), 'B', Obs_HEM OBS_HOU, CNS.Nome_Raz_Soc CNS, LDE.Nome_Local Local_Desemb,
			dbo.fBusca_Tarefa(HOU.Num_Proc_HEM,4) Dt_Desembaraco,Data_PC,fatDtVenc Vencimento,isnull(Ordem,99) Order_By
		FROM 
			FATURA_CHB FAT
			left Join Tipo_Taxa_PC_CHB TCHB on cd_pes_grupo=@cd_pes and TCHB.Modal=left(fatura_pc,1)
			Left JOIN FATURA_CHB_ITEM ITM ON ITM.FATURA_CC=FAT.FATURA_PC and TCHB.cd_Tp_Tx=ITM.cd_tp_Tx
			JOIN PESSOA PP ON PP.CD_PES=CD_PES_PC
			LEFT Join Endereco ED on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
			LEFT JOIN HOUSE_EXP_Mar HOU ON HOU.NUM_PROC_HEM=LEFT(FATURA_PC,16)
			LEft join Tipo_Taxa TT on TT.cd_tp_Tx=itm.cd_tp_Tx
			LEft Join PO_HEM PO on lefT(fat.fatura_pc,16)=po.num_proC_HEM  AND ID_DC = 1
			Join Localidade Org on Org.cd_local=cd_org_HEM
			Join Localidade dst on dst.cd_local=cd_dst_HEM
			left join Pessoa CNS on CNS.cd_pes = HOU.cd_Export_HEM
			Left Join Campo_Processo CP on CP.Num_Proc=left(@Fatura_PC,16) and Id_Campo=25
			Left Join Localidade LDE on LDE.cd_local=CP.Campo_Dados
			Left Join Fatura on fatcod=fatura_pc

		WHERE 
			(cd_pes_grupo is not null and nome_tp_Tx is null) and FATURA_PC=@FATURA_PC 
		group by 
			HOU.Num_Proc_HEM,Data_PC,fatdtvenc,obs_PC,obs_HEM,right(pp.Num_CPF_CNPJ,14), Fatura_PC,pp.Apelido,pp.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,hawb_HEM ,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, CNS.Nome_Raz_Soc, LDE.Nome_Local,isnull(Ordem,99) ,DESCRICAO,TCHB.cd_Tp_Tx	


	UNION ALL
	--HEA (EXPORTAÇÃO AÉREA)

		SELECT 
			Data_PC,F.fatDtVenc,Obs_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ ,Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,RUA,Numero,Cidade,UF,max(Numero_PO_HEA) Referencia_Cliente,DI_RE_PC,org.nome_local Origem, dst.nome_local Destino,hawb_HEA House,IFT.CD_TP_TX,isnull(descricao,NOME_TP_TX) + ' ('+ @fatcod + ')' Nome_Tp_Tx,IFT.Vlr_RS VLR_PC,  'B'  TP_PGTO, Obs_HEA OBS_HOU, CNS.Nome_Raz_Soc CNS, LDE.Nome_Local Local_Desemb,
			dbo.fBusca_Tarefa(HOU.Num_Proc_HEA,4) Dt_Desembaraco,Data_PC,F.fatDtVenc Vencimento, isnull(Ordem,99) Order_By
		FROM 
			FATURA_CHB FAT
			JOIN FATURA_CHB_ITEM ITM ON ITM.FATURA_CC=FAT.FATURA_PC
			Join Fatura FT with(nolock)on FT.fatcod=@fatcod
			Join Item_Fat IFT with(nolock)on FT.fatcod = IFT.FatCod
			JOIN PESSOA PP ON PP.CD_PES=CD_PES_PC 
			LEFT Join Endereco ED on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
			LEFT JOIN HOUSE_EXP_AER HOU ON HOU.NUM_PROC_HEA=LEFT(FATURA_PC,16)
			join Tipo_Taxa TT on TT.cd_tp_Tx=IFT.cd_tp_Tx
			LEft Join PO_HEA PO on lefT(fat.fatura_pc,16)=po.num_proC_HEA AND ID_DC = 1
			Join Localidade Org on Org.cd_local=cd_org_HEA
			Join Localidade dst on dst.cd_local=cd_dst_HEA
			left join Pessoa CNS on CNS.cd_pes = HOU.CD_CONSIG_HEA
			Left Join Campo_Processo CP on CP.Num_Proc=left(@Fatura_PC,16) and Id_Campo=25
			Left Join Localidade LDE on LDE.cd_local=CP.Campo_Dados
			Left Join Fatura F on F.fatcod=fatura_pc
			Left Join Tipo_Taxa_PC_CHB TCHB on TCHB.cd_tp_tx=TT.cd_tp_tx and cd_pes_grupo=@cd_pes and TCHB.Modal=left(fatura_pc,1)
		WHERE 
			FATURA_PC=@FATURA_PC and @Tipo='S'
		GROUP BY
			HOU.Num_Proc_HEA, Data_pc,F.fatdtvenc,Obs_Pc,Obs_HEA,right(PP.Num_CPF_CNPJ,14),Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,hawb_HEA ,IFT.CD_TP_TX,NOME_TP_TX,IFT.Vlr_RS, TP_PGTO, CNS.Nome_Raz_Soc, LDE.Nome_Local,
			Descricao,isnull(Ordem,99) 
	union all
		SELECT 
			Data_PC,fatDtVenc,Obs_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ ,Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,RUA,Numero,Cidade,UF,max(Numero_PO_HEA) Referencia_Cliente,DI_RE_PC,org.nome_local Origem, dst.nome_local Destino,hawb_HEA House,ITM.CD_TP_TX,isnull(descricao,NOME_TP_TX) Nome_Tp_Tx,VLR_PC, TP_PGTO, Obs_HEA OBS_HOU, CNS.Nome_Raz_Soc CNS, LDE.Nome_Local Local_Desemb,
			dbo.fBusca_Tarefa(HOU.Num_Proc_HEA,4) Dt_Desembaraco,Data_PC,fatDtVenc Vencimento, isnull(Ordem,99) Order_By
		FROM 
			FATURA_CHB FAT
			JOIN FATURA_CHB_ITEM ITM ON ITM.FATURA_CC=FAT.FATURA_PC
			JOIN PESSOA PP ON PP.CD_PES=CD_PES_PC 
			LEFT Join Endereco ED on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
			LEFT JOIN HOUSE_EXP_Aer HOU ON HOU.NUM_PROC_HEA=LEFT(FATURA_PC,16)
			join Tipo_Taxa TT on TT.cd_tp_Tx=itm.cd_tp_Tx
			LEft Join PO_HEA PO on lefT(fat.fatura_pc,16)=po.num_proC_HEA AND ID_DC = 1
			Join Localidade Org on Org.cd_local=cd_org_HEA
			Join Localidade dst on dst.cd_local=cd_dst_HEA
			left join Pessoa CNS on CNS.cd_pes = HOU.cd_export_HEA
			Left Join Campo_Processo CP on CP.Num_Proc=left(@Fatura_PC,16) and Id_Campo=25
			Left Join Localidade LDE on LDE.cd_local=CP.Campo_Dados
			Left Join Fatura on fatcod=fatura_pc
			Left Join Tipo_Taxa_PC_CHB TCHB on TCHB.cd_tp_tx=TT.cd_tp_tx and cd_pes_grupo=@cd_pes
		WHERE 
			(FATURA_PC=@FATURA_PC and imprime='S' and @Tipo='S')
			or
			(FATURA_PC=@FATURA_PC and @Tipo='C')
		GROUP BY
			HOU.Num_Proc_HEA, Data_pc,fatdtvenc,Obs_Pc,Obs_HEA,right(PP.Num_CPF_CNPJ,14),Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,hawb_HEA ,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, CNS.Nome_Raz_Soc, LDE.Nome_Local,
			Descricao,isnull(Ordem,99) 
		
		Union All

		SELECT 
			Data_PC,fatdtvenc,OBS_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ ,Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,RUA,Numero,Cidade,UF,max(Numero_PO_HEA) Referencia_Cliente,DI_RE_PC,org.nome_local Origem, dst.nome_local Destino,hawb_HEA House,TCHB.CD_TP_TX,isnull(descricao,NOME_TP_TX) Nome_tp_Tx,Isnull(VLR_PC,0), 'B', Obs_HEA OBS_HOU, CNS.Nome_Raz_Soc CNS, LDE.Nome_Local Local_Desemb,
			dbo.fBusca_Tarefa(HOU.Num_Proc_HEA,4) Dt_Desembaraco,Data_PC,fatDtVenc Vencimento,isnull(Ordem,99) Order_By
		FROM 
			FATURA_CHB FAT
			left Join Tipo_Taxa_PC_CHB TCHB on cd_pes_grupo=@cd_pes and TCHB.Modal=left(fatura_pc,1)
			Left JOIN FATURA_CHB_ITEM ITM ON ITM.FATURA_CC=FAT.FATURA_PC and TCHB.cd_Tp_Tx=ITM.cd_tp_Tx
			JOIN PESSOA PP ON PP.CD_PES=CD_PES_PC
			LEFT Join Endereco ED on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
			LEFT JOIN HOUSE_EXP_Aer HOU ON HOU.NUM_PROC_HEA=LEFT(FATURA_PC,16)
			LEft join Tipo_Taxa TT on TT.cd_tp_Tx=itm.cd_tp_Tx
			LEft Join PO_HEA PO on lefT(fat.fatura_pc,16)=po.num_proC_HEA  AND ID_DC = 1
			Join Localidade Org on Org.cd_local=cd_org_HEA
			Join Localidade dst on dst.cd_local=cd_dst_HEA
			left join Pessoa CNS on CNS.cd_pes = HOU.cd_Export_HEA
			Left Join Campo_Processo CP on CP.Num_Proc=left(@Fatura_PC,16) and Id_Campo=25
			Left Join Localidade LDE on LDE.cd_local=CP.Campo_Dados
			Left Join Fatura on fatcod=fatura_pc

		WHERE 
			(cd_pes_grupo is not null and nome_tp_Tx is null) and FATURA_PC=@FATURA_PC 
		group by 
			HOU.Num_Proc_HEA,Data_PC,fatdtvenc,obs_PC,obs_HEA,right(pp.Num_CPF_CNPJ,14), Fatura_PC,pp.Apelido,pp.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,hawb_HEA ,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, CNS.Nome_Raz_Soc, LDE.Nome_Local,isnull(Ordem,99) ,DESCRICAO,TCHB.cd_Tp_Tx	


	union all

	-- HIO (IMPORTAÇÃO OUTROS)
	
		SELECT 
			Data_PC,F.fatDtVenc,Obs_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ ,Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,RUA,Numero,Cidade,UF,max(Numero_PO_HIO) Referencia_Cliente,DI_RE_PC,org.nome_local Origem, dst.nome_local Destino,hawb_HIO House,IFT.CD_TP_TX,isnull(descricao,NOME_TP_TX) + ' ('+ @fatcod + ')' Nome_Tp_Tx,IFT.Vlr_RS VLR_PC,  'B'  TP_PGTO, Obs_HIO OBS_HOU, CNS.Nome_Raz_Soc CNS, LDE.Nome_Local Local_Desemb,
			dbo.fBusca_Tarefa(HOU.Num_Proc_HIO,4) Dt_Desembaraco,Data_PC,F.fatDtVenc Vencimento, isnull(Ordem,99) Order_By
		FROM 
			FATURA_CHB FAT
			JOIN FATURA_CHB_ITEM ITM ON ITM.FATURA_CC=FAT.FATURA_PC
			Join Fatura FT with(nolock)on FT.fatcod=@fatcod
			Join Item_Fat IFT with(nolock)on FT.fatcod = IFT.FatCod
			JOIN PESSOA PP ON PP.CD_PES=CD_PES_PC 
			LEFT Join Endereco ED on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
			LEFT JOIN HOUSE_IMP_OUT HOU ON HOU.NUM_PROC_HIO=LEFT(FATURA_PC,16)
			join Tipo_Taxa TT on TT.cd_tp_Tx=IFT.cd_tp_Tx
			LEft Join PO_HIO PO on lefT(fat.fatura_pc,16)=po.num_proC_HIO AND ID_DC = 1
			Join Localidade Org on Org.cd_local=cd_org_HIO
			Join Localidade dst on dst.cd_local=cd_dst_HIO
			left join Pessoa CNS on CNS.cd_pes = HOU.CD_CONSIG_HIO
			Left Join Campo_Processo CP on CP.Num_Proc=left(@Fatura_PC,16) and Id_Campo=25
			Left Join Localidade LDE on LDE.cd_local=CP.Campo_Dados
			Left Join Fatura F on F.fatcod=fatura_pc
			Left Join Tipo_Taxa_PC_CHB TCHB on TCHB.cd_tp_tx=TT.cd_tp_tx and cd_pes_grupo=@cd_pes and TCHB.Modal=left(fatura_pc,1)
		WHERE 
			FATURA_PC=@FATURA_PC and @Tipo='S'
		GROUP BY
			HOU.Num_Proc_HIO, Data_pc,F.fatdtvenc,Obs_Pc,Obs_HIO,right(PP.Num_CPF_CNPJ,14),Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,hawb_HIO ,IFT.CD_TP_TX,NOME_TP_TX,IFT.Vlr_RS, TP_PGTO, CNS.Nome_Raz_Soc, LDE.Nome_Local,
			Descricao,isnull(Ordem,99) 
	union all
		SELECT 
			Data_PC,fatDtVenc,Obs_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ ,Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,RUA,Numero,Cidade,UF,max(Numero_PO_HIO) Referencia_Cliente,DI_RE_PC,org.nome_local Origem, dst.nome_local Destino,hawb_HIO House,ITM.CD_TP_TX,isnull(descricao,NOME_TP_TX) Nome_Tp_Tx,VLR_PC, TP_PGTO, Obs_HIO OBS_HOU, CNS.Nome_Raz_Soc CNS, LDE.Nome_Local Local_Desemb,
			dbo.fBusca_Tarefa(HOU.Num_Proc_HIO,4) Dt_Desembaraco,Data_PC,fatDtVenc Vencimento, isnull(Ordem,99) Order_By
		FROM 
			FATURA_CHB FAT
			JOIN FATURA_CHB_ITEM ITM ON ITM.FATURA_CC=FAT.FATURA_PC
			JOIN PESSOA PP ON PP.CD_PES=CD_PES_PC 
			LEFT Join Endereco ED on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
			LEFT JOIN HOUSE_IMP_OUT HOU ON HOU.NUM_PROC_HIO=LEFT(FATURA_PC,16)
			join Tipo_Taxa TT on TT.cd_tp_Tx=itm.cd_tp_Tx
			LEft Join PO_HIO PO on lefT(fat.fatura_pc,16)=po.num_proC_HIO AND ID_DC = 1
			Join Localidade Org on Org.cd_local=cd_org_HIO
			Join Localidade dst on dst.cd_local=cd_dst_HIO
			left join Pessoa CNS on CNS.cd_pes = HOU.CD_CONSIG_HIO
			Left Join Campo_Processo CP on CP.Num_Proc=left(@Fatura_PC,16) and Id_Campo=25
			Left Join Localidade LDE on LDE.cd_local=CP.Campo_Dados
			Left Join Fatura on fatcod=fatura_pc
			Left Join Tipo_Taxa_PC_CHB TCHB on TCHB.cd_tp_tx=TT.cd_tp_tx and cd_pes_grupo=@cd_pes
		WHERE 
			(FATURA_PC=@FATURA_PC and imprime='S' and @Tipo='S')
			or
			(FATURA_PC=@FATURA_PC and @Tipo='C')
		GROUP BY
			HOU.Num_Proc_HIO, Data_pc,fatdtvenc,Obs_Pc,Obs_HIO,right(PP.Num_CPF_CNPJ,14),Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,hawb_HIO ,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, CNS.Nome_Raz_Soc, LDE.Nome_Local,
			Descricao,isnull(Ordem,99) 
		
		Union All

		SELECT 
			Data_PC,fatdtvenc,OBS_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ ,Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,RUA,Numero,Cidade,UF,max(Numero_PO_HIO) Referencia_Cliente,DI_RE_PC,org.nome_local Origem, dst.nome_local Destino,hawb_HIO House,TCHB.CD_TP_TX,isnull(descricao,NOME_TP_TX) Nome_tp_Tx,Isnull(VLR_PC,0), 'B', Obs_HIO OBS_HOU, CNS.Nome_Raz_Soc CNS, LDE.Nome_Local Local_Desemb,
			dbo.fBusca_Tarefa(HOU.Num_Proc_HIO,4) Dt_Desembaraco,Data_PC,fatDtVenc Vencimento,isnull(Ordem,99) Order_By
		FROM 
			FATURA_CHB FAT
			left Join Tipo_Taxa_PC_CHB TCHB on cd_pes_grupo=@cd_pes and TCHB.Modal=left(fatura_pc,1)
			Left JOIN FATURA_CHB_ITEM ITM ON ITM.FATURA_CC=FAT.FATURA_PC and TCHB.cd_Tp_Tx=ITM.cd_tp_Tx
			JOIN PESSOA PP ON PP.CD_PES=CD_PES_PC
			LEFT Join Endereco ED on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
			LEFT JOIN HOUSE_IMP_OUT HOU ON HOU.NUM_PROC_HIO=LEFT(FATURA_PC,16)
			LEft join Tipo_Taxa TT on TT.cd_tp_Tx=itm.cd_tp_Tx
			LEft Join PO_HIO PO on lefT(fat.fatura_pc,16)=po.num_proC_HIO  AND ID_DC = 1
			Join Localidade Org on Org.cd_local=cd_org_HIO
			Join Localidade dst on dst.cd_local=cd_dst_HIO
			left join Pessoa CNS on CNS.cd_pes = HOU.CD_CONSIG_HIO
			Left Join Campo_Processo CP on CP.Num_Proc=left(@Fatura_PC,16) and Id_Campo=25
			Left Join Localidade LDE on LDE.cd_local=CP.Campo_Dados
			Left Join Fatura on fatcod=fatura_pc

		WHERE 
--			(FATURA_PC=@FATURA_PC and imprime='S' and @Tipo='S')
--			or
--			(FATURA_PC=@FATURA_PC and @Tipo='C')
		--estava como o de cima, mudei pro abaixo
			(cd_pes_grupo is not null and nome_tp_Tx is null) and FATURA_PC=@FATURA_PC 
		group by 
			HOU.Num_Proc_HIO,Data_PC,fatdtvenc,obs_PC,obs_HIO,right(pp.Num_CPF_CNPJ,14), Fatura_PC,pp.Apelido,pp.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,hawb_HIO ,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, CNS.Nome_Raz_Soc, LDE.Nome_Local,isnull(Ordem,99) ,DESCRICAO,TCHB.cd_Tp_Tx	

	--HIM (IMPORTAÇÃO MARITIMA)

	union all
		SELECT 
			Data_PC,F.fatDtVenc,Obs_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ ,Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,RUA,Numero,Cidade,UF,max(Numero_PO_HIM) Referencia_Cliente,DI_RE_PC,org.nome_local Origem, dst.nome_local Destino,hawb_HIM House,IFT.CD_TP_TX,isnull(descricao,NOME_TP_TX) + ' ('+ @fatcod + ')' Nome_Tp_Tx,IFT.Vlr_RS VLR_PC,  'B'  TP_PGTO, Obs_HIM OBS_HOU, CNS.Nome_Raz_Soc CNS, LDE.Nome_Local Local_Desemb,
			dbo.fBusca_Tarefa(HOU.Num_Proc_HIM,4) Dt_Desembaraco,Data_PC,F.fatDtVenc Vencimento, isnull(Ordem,99) Order_By
		FROM 
			FATURA_CHB FAT
			JOIN FATURA_CHB_ITEM ITM ON ITM.FATURA_CC=FAT.FATURA_PC
			Join Fatura FT with(nolock)on FT.fatcod=@fatcod
			Join Item_Fat IFT with(nolock)on FT.fatcod = IFT.FatCod
			JOIN PESSOA PP ON PP.CD_PES=CD_PES_PC 
			LEFT Join Endereco ED on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
			LEFT JOIN HOUSE_IMP_Mar HOU ON HOU.NUM_PROC_HIM=LEFT(FATURA_PC,16)
			join Tipo_Taxa TT on TT.cd_tp_Tx=IFT.cd_tp_Tx
			LEft Join PO_HIM PO on lefT(fat.fatura_pc,16)=po.num_proC_HIM AND ID_DC = 1
			Join Localidade Org on Org.cd_local=cd_org_HIM
			Join Localidade dst on dst.cd_local=cd_dst_HIM
			left join Pessoa CNS on CNS.cd_pes = HOU.CD_CONSIG_HIM
			Left Join Campo_Processo CP on CP.Num_Proc=left(@Fatura_PC,16) and Id_Campo=25
			Left Join Localidade LDE on LDE.cd_local=CP.Campo_Dados
			Left Join Fatura F on F.fatcod=fatura_pc
			Left Join Tipo_Taxa_PC_CHB TCHB on TCHB.cd_tp_tx=TT.cd_tp_tx and cd_pes_grupo=@cd_pes and TCHB.Modal=left(fatura_pc,1)
		WHERE 
			FATURA_PC=@FATURA_PC and @Tipo='S'
		GROUP BY
			HOU.Num_Proc_HIM, Data_pc,F.fatdtvenc,Obs_Pc,Obs_HIM,right(PP.Num_CPF_CNPJ,14),Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,hawb_HIM ,IFT.CD_TP_TX,NOME_TP_TX,IFT.Vlr_RS, TP_PGTO, CNS.Nome_Raz_Soc, LDE.Nome_Local,
			Descricao,isnull(Ordem,99) 
	
	union all

		SELECT 
			Data_PC,fatDtVenc,Obs_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ ,Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,RUA,Numero,Cidade,UF,max(Numero_PO_HIM) Referencia_Cliente,DI_RE_PC,org.nome_local Origem, dst.nome_local Destino,hawb_HIM House,ITM.CD_TP_TX,isnull(descricao,NOME_TP_TX) Nome_Tp_Tx,VLR_PC, TP_PGTO, Obs_HIM OBS_HOU, CNS.Nome_Raz_Soc CNS, LDE.Nome_Local Local_Desemb,
			dbo.fBusca_Tarefa(HOU.Num_Proc_HIM,4) Dt_Desembaraco,Data_PC,fatDtVenc Vencimento, isnull(Ordem,99) Order_By
		FROM 
			FATURA_CHB FAT
			JOIN FATURA_CHB_ITEM ITM ON ITM.FATURA_CC=FAT.FATURA_PC
			JOIN PESSOA PP ON PP.CD_PES=CD_PES_PC 
			LEFT Join Endereco ED on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
			LEFT JOIN HOUSE_IMP_Mar HOU ON HOU.NUM_PROC_HIM=LEFT(FATURA_PC,16)
			join Tipo_Taxa TT on TT.cd_tp_Tx=itm.cd_tp_Tx
			LEft Join PO_HIM PO on lefT(fat.fatura_pc,16)=po.num_proC_HIM AND ID_DC = 1
			Join Localidade Org on Org.cd_local=cd_org_HIM
			Join Localidade dst on dst.cd_local=cd_dst_HIM
			left join Pessoa CNS on CNS.cd_pes = HOU.CD_CONSIG_HIM
			Left Join Campo_Processo CP on CP.Num_Proc=left(@Fatura_PC,16) and Id_Campo=25
			Left Join Localidade LDE on LDE.cd_local=CP.Campo_Dados
			Left Join Fatura on fatcod=fatura_pc
			Left Join Tipo_Taxa_PC_CHB TCHB on TCHB.cd_tp_tx=TT.cd_tp_tx and cd_pes_grupo=@cd_pes and TCHB.Modal=left(fatura_pc,1)
		WHERE 
			(FATURA_PC=@FATURA_PC and imprime='S' and @Tipo='S')
			or
			(FATURA_PC=@FATURA_PC and @Tipo='C')
		GROUP BY
			HOU.Num_Proc_HIM, Data_pc,fatdtvenc,Obs_Pc,Obs_HIM,right(PP.Num_CPF_CNPJ,14),Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,hawb_HIM ,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, CNS.Nome_Raz_Soc, LDE.Nome_Local,
			Descricao,isnull(Ordem,99) 
		
		Union All

		SELECT 
			Data_PC,fatdtvenc,OBS_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ ,Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,RUA,Numero,Cidade,UF,max(Numero_PO_HIM) Referencia_Cliente,DI_RE_PC,org.nome_local Origem, dst.nome_local Destino,hawb_HIM House,TCHB.CD_TP_TX,isnull(descricao,NOME_TP_TX) Nome_tp_Tx,Isnull(VLR_PC,0), 'B', Obs_HIM OBS_HOU, CNS.Nome_Raz_Soc CNS, LDE.Nome_Local Local_Desemb,
			dbo.fBusca_Tarefa(HOU.Num_Proc_HIM,4) Dt_Desembaraco,Data_PC,fatDtVenc Vencimento,isnull(Ordem,99) Order_By
		FROM 
			FATURA_CHB FAT
			left Join Tipo_Taxa_PC_CHB TCHB on cd_pes_grupo=@cd_pes and TCHB.Modal=left(fatura_pc,1)
			Left JOIN FATURA_CHB_ITEM ITM ON ITM.FATURA_CC=FAT.FATURA_PC and TCHB.cd_Tp_Tx=ITM.cd_tp_Tx
			JOIN PESSOA PP ON PP.CD_PES=CD_PES_PC
			LEFT Join Endereco ED on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
			LEFT JOIN HOUSE_IMP_Mar HOU ON HOU.NUM_PROC_HIM=LEFT(FATURA_PC,16)
			LEft join Tipo_Taxa TT on TT.cd_tp_Tx=itm.cd_tp_Tx
			LEft Join PO_HIM PO on lefT(fat.fatura_pc,16)=po.num_proC_HIM  AND ID_DC = 1
			Join Localidade Org on Org.cd_local=cd_org_HIM
			Join Localidade dst on dst.cd_local=cd_dst_HIM
			left join Pessoa CNS on CNS.cd_pes = HOU.CD_CONSIG_HIM
			Left Join Campo_Processo CP on CP.Num_Proc=left(@Fatura_PC,16) and Id_Campo=25
			Left Join Localidade LDE on LDE.cd_local=CP.Campo_Dados
			Left Join Fatura on fatcod=fatura_pc

		WHERE 
--			(FATURA_PC=@FATURA_PC and imprime='S' and @Tipo='S')
--			or
--			(FATURA_PC=@FATURA_PC and @Tipo='C')
			--estava como o de cima, mudei pro abaixo q era o qestava nos outros modais(kick)
			(cd_pes_grupo is not null and nome_tp_Tx is null) and FATURA_PC=@FATURA_PC 
		group by 		
			HOU.Num_Proc_HIM,Data_PC,fatdtvenc,obs_PC,obs_HIM,right(pp.Num_CPF_CNPJ,14), Fatura_PC,pp.Apelido,pp.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,hawb_HIM ,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, CNS.Nome_Raz_Soc, LDE.Nome_Local,isnull(Ordem,99) ,DESCRICAO,TCHB.cd_Tp_Tx	


	UNION ALL

	--HIA (IMPORTAÇÃO AÉREA)

		SELECT 
			Data_PC,F.fatDtVenc,Obs_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ ,Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,RUA,Numero,Cidade,UF,max(Numero_PO_HIA) Referencia_Cliente,DI_RE_PC,org.nome_local Origem, dst.nome_local Destino,hawb_HIA House,IFT.CD_TP_TX,isnull(descricao,NOME_TP_TX) + ' ('+ @fatcod + ')' Nome_Tp_Tx,IFT.Vlr_RS VLR_PC,  'B'  TP_PGTO, Obs_HIA OBS_HOU, CNS.Nome_Raz_Soc CNS, LDE.Nome_Local Local_Desemb,
			dbo.fBusca_Tarefa(HOU.Num_Proc_HIA,4) Dt_Desembaraco,Data_PC,F.fatDtVenc Vencimento, isnull(Ordem,99) Order_By
		FROM 
			FATURA_CHB FAT
			JOIN FATURA_CHB_ITEM ITM ON ITM.FATURA_CC=FAT.FATURA_PC
			Join Fatura FT with(nolock)on FT.fatcod=@fatcod
			Join Item_Fat IFT with(nolock)on FT.fatcod = IFT.FatCod
			JOIN PESSOA PP ON PP.CD_PES=CD_PES_PC 
			LEFT Join Endereco ED on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
			LEFT JOIN HOUSE_IMP_AER HOU ON HOU.NUM_PROC_HIA=LEFT(FATURA_PC,16)
			join Tipo_Taxa TT on TT.cd_tp_Tx=IFT.cd_tp_Tx
			LEft Join PO_HIA PO on lefT(fat.fatura_pc,16)=po.num_proC_HIA AND ID_DC = 1
			Join Localidade Org on Org.cd_local=cd_org_HIA
			Join Localidade dst on dst.cd_local=cd_dst_HIA
			left join Pessoa CNS on CNS.cd_pes = HOU.CD_CONSIG_HIA
			Left Join Campo_Processo CP on CP.Num_Proc=left(@Fatura_PC,16) and Id_Campo=25
			Left Join Localidade LDE on LDE.cd_local=CP.Campo_Dados
			Left Join Fatura F on F.fatcod=fatura_pc
			Left Join Tipo_Taxa_PC_CHB TCHB on TCHB.cd_tp_tx=TT.cd_tp_tx and cd_pes_grupo=@cd_pes and TCHB.Modal=left(fatura_pc,1)
		WHERE 
			FATURA_PC=@FATURA_PC and @Tipo='S'
		GROUP BY
			HOU.Num_Proc_HIA, Data_pc,F.fatdtvenc,Obs_Pc,Obs_HIA,right(PP.Num_CPF_CNPJ,14),Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,hawb_HIA ,IFT.CD_TP_TX,NOME_TP_TX,IFT.Vlr_RS, TP_PGTO, CNS.Nome_Raz_Soc, LDE.Nome_Local,
			Descricao,isnull(Ordem,99) 
	union all
		SELECT 
			Data_PC,fatDtVenc,Obs_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ ,Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,RUA,Numero,Cidade,UF,max(Numero_PO_HIA) Referencia_Cliente,DI_RE_PC,org.nome_local Origem, dst.nome_local Destino,hawb_HIA House,ITM.CD_TP_TX,isnull(descricao,NOME_TP_TX) Nome_Tp_Tx,VLR_PC, TP_PGTO, Obs_HIA OBS_HOU, CNS.Nome_Raz_Soc CNS, LDE.Nome_Local Local_Desemb,
			dbo.fBusca_Tarefa(HOU.Num_Proc_HIA,4) Dt_Desembaraco,Data_PC,fatDtVenc Vencimento, isnull(Ordem,99) Order_By
		FROM 
			FATURA_CHB FAT
			JOIN FATURA_CHB_ITEM ITM ON ITM.FATURA_CC=FAT.FATURA_PC
			JOIN PESSOA PP ON PP.CD_PES=CD_PES_PC 
			LEFT Join Endereco ED on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
			LEFT JOIN HOUSE_IMP_Aer HOU ON HOU.NUM_PROC_HIA=LEFT(FATURA_PC,16)
			join Tipo_Taxa TT on TT.cd_tp_Tx=itm.cd_tp_Tx
			LEft Join PO_HIA PO on lefT(fat.fatura_pc,16)=po.num_proC_HIA AND ID_DC = 1
			Join Localidade Org on Org.cd_local=cd_org_HIA
			Join Localidade dst on dst.cd_local=cd_dst_HIA
			left join Pessoa CNS on CNS.cd_pes = HOU.CD_CONSIG_HIA
			Left Join Campo_Processo CP on CP.Num_Proc=left(@Fatura_PC,16) and Id_Campo=25
			Left Join Localidade LDE on LDE.cd_local=CP.Campo_Dados
			Left Join Fatura on fatcod=fatura_pc
			Left Join Tipo_Taxa_PC_CHB TCHB on TCHB.cd_tp_tx=TT.cd_tp_tx and cd_pes_grupo=@cd_pes
		WHERE 
			(FATURA_PC=@FATURA_PC and imprime='S' and @Tipo='S')
			or
			(FATURA_PC=@FATURA_PC and @Tipo='C')
		GROUP BY
			HOU.Num_Proc_HIA, Data_pc,fatdtvenc,Obs_Pc,Obs_HIA,right(PP.Num_CPF_CNPJ,14),Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,hawb_HIA ,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, CNS.Nome_Raz_Soc, LDE.Nome_Local,
			Descricao,isnull(Ordem,99) 
		
		Union All

		SELECT 
			Data_PC,fatdtvenc,OBS_PC OBS,right(PP.Num_CPF_CNPJ,14) Num_CPF_CNPJ ,Fatura_PC,PP.Apelido,PP.Nome_Raz_Soc,RUA,Numero,Cidade,UF,max(Numero_PO_HIA) Referencia_Cliente,DI_RE_PC,org.nome_local Origem, dst.nome_local Destino,hawb_HIA House,TCHB.CD_TP_TX,isnull(descricao,NOME_TP_TX) Nome_tp_Tx,Isnull(VLR_PC,0), 'B', Obs_HIA OBS_HOU, CNS.Nome_Raz_Soc CNS, LDE.Nome_Local Local_Desemb,
			dbo.fBusca_Tarefa(HOU.Num_Proc_HIA,4) Dt_Desembaraco,Data_PC,fatDtVenc Vencimento,isnull(Ordem,99) Order_By
		FROM 
			FATURA_CHB FAT
			left Join Tipo_Taxa_PC_CHB TCHB on cd_pes_grupo=@cd_pes and TCHB.Modal=left(fatura_pc,1)
			Left JOIN FATURA_CHB_ITEM ITM ON ITM.FATURA_CC=FAT.FATURA_PC and TCHB.cd_Tp_Tx=ITM.cd_tp_Tx
			JOIN PESSOA PP ON PP.CD_PES=CD_PES_PC
			LEFT Join Endereco ED on ED.cd_pes=cd_pes_PC and ed.cd_tp_end='COM'
			LEFT JOIN HOUSE_IMP_Aer HOU ON HOU.NUM_PROC_HIA=LEFT(FATURA_PC,16)
			LEft join Tipo_Taxa TT on TT.cd_tp_Tx=itm.cd_tp_Tx
			LEft Join PO_HIA PO on lefT(fat.fatura_pc,16)=po.num_proC_HIA  AND ID_DC = 1
			Join Localidade Org on Org.cd_local=cd_org_HIA
			Join Localidade dst on dst.cd_local=cd_dst_HIA
			left join Pessoa CNS on CNS.cd_pes = HOU.CD_CONSIG_HIA
			Left Join Campo_Processo CP on CP.Num_Proc=left(@Fatura_PC,16) and Id_Campo=25
			Left Join Localidade LDE on LDE.cd_local=CP.Campo_Dados
			Left Join Fatura on fatcod=fatura_pc

		WHERE 
			(cd_pes_grupo is not null and nome_tp_Tx is null) and FATURA_PC=@FATURA_PC 
		group by 
			HOU.Num_Proc_HIA,Data_PC,fatdtvenc,obs_PC,obs_HIA,right(pp.Num_CPF_CNPJ,14), Fatura_PC,pp.Apelido,pp.Nome_Raz_Soc,RUA,Numero,Cidade,UF,DI_RE_PC,org.nome_local , dst.nome_local ,hawb_HIA ,ITM.CD_TP_TX,NOME_TP_TX,VLR_PC, TP_PGTO, CNS.Nome_Raz_Soc, LDE.Nome_Local,isnull(Ordem,99) ,DESCRICAO,TCHB.cd_Tp_Tx	

	Order by order_by
	End

GO
