SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--28-01-2015 - Erbson: Alterado para utilizar a Tabela de Net_Revenue_Temp e não mais a função
--[spBuscaStatusAberto_Sel] 8

--Cadu 04/03/2016 - 19:00hs
--Status= 3 - Sem Desembaraço - Cadu 13/05 - 10:27


CREATE Procedure [dbo].[spBuscaStatusAberto_Sel]--4
		@ID_Status int

AS

Declare @Status Varchar(50)
Set @Status= (select cast(ID_Status as varchar(3)) + ' - ' + Status_Descricao from tipo_status_processo With(nolock) where id_status=@id_status)

If @ID_Status=1 
	Begin
		select Num_Proc_LiA Num_Proc,@Status Status from llp_imp_Aer With(nolock) where (atd_lia is null or atd_lia > '2019-01-01') and id_status is null	
		
		Union All

		select Num_Proc_LiM Num_Proc,@Status Status from llp_imp_Mar With(nolock) where  (atd_lim is null or atd_lim > '2019-01-01') and id_status is null	

		Union All

		select Num_Proc_Lio Num_Proc,@Status Status from llp_imp_Out With(nolock) where  (atd_lio is null or atd_lio > '2019-01-01') and id_status is null	

		Union All

		select Num_Proc_LEA Num_Proc,@Status Status from llp_Exp_Aer With(nolock) where  (atd_lea is null or atd_lea > '2019-01-01') and id_status is null	

		Union All

		select Num_Proc_LEM Num_Proc,@Status Status from llp_Exp_Mar With(nolock) where  (atd_lem is null or atd_lem > '2019-01-01') and id_status is null	

		Union All

		Select Num_Proc_LEO Num_Proc,@Status Status From LLP_Exp_Out With(nolock) Where  (ATD_LEO is null or ATD_LEO > '2019-01-01') and id_status is null	
	OPTION (HASH JOIN)
	End


If @ID_Status=2 
	Begin
		select Num_Proc_LiA Num_Proc,@Status Status from llp_imp_Aer With(nolock) where atd_lia is not null and ata_lia is null and isnull(id_Status,0) <=1
		
		Union All

		select Num_Proc_Lim Num_Proc,@Status Status from llp_imp_mar With(nolock) where atd_lim is not null and ata_lim is null and isnull(id_Status,0) <=1

		Union All

		select Num_Proc_Lio Num_Proc,@Status Status from llp_imp_out With(nolock) where atd_lio is not null and ata_lio is null and isnull(id_Status,0) <=1

		Union All

		select Num_Proc_LEA Num_Proc,@Status Status from llp_exp_Aer With(nolock) where atd_lea is not null and ata_lea is null and isnull(id_Status,0) <=1

		Union All

		select Num_Proc_LEM Num_Proc,@Status Status from llp_exp_mar With(nolock) where atd_lem is not null and ata_lem is null and isnull(id_Status,0) <=1

		Union All

		select Num_Proc_LEO Num_Proc,@Status Status from llp_exp_out With(nolock) where atd_leo is not null and ata_leo is null and isnull(id_Status,0) <=1
OPTION (HASH JOIN)
	End

If @ID_Status=3 
	Begin

--Importação Aérea
		Select Num_Proc_LIA Num_Proc,@Status Status From LLP_Imp_Aer LLP With(nolock) 
		Left Join Campo_Processo	CP With(nolock) on CP.num_proc=num_proc_lia and Id_Campo=32
		Join Tarefas_Processos		TP With(nolock) on TP.num_Proc=Num_Proc_LIA and Id_Task=4
		Where 
			(Campo_Dados=1 or Campo_Dados is null) and DT_Conclusao Is Null
			And ATA_LIA >=getdate()-30
			and Isnull(ID_STatus,0)<=2
--Importação Marítima
Union All
		Select Num_Proc_LIM,@Status Status From LLP_Imp_Mar LLP With(nolock) 
		Left Join Campo_Processo	CP With(nolock) on CP.num_proc=num_proc_lim and Id_Campo=32
		Join Tarefas_Processos		TP With(nolock) on TP.num_Proc=Num_Proc_LIm and Id_Task=4
		Where 
			(Campo_Dados=1 or Campo_Dados is null) and DT_Conclusao Is Null
			And ATA_LIm >=getdate()-30
			and Isnull(ID_STatus,0)<=2
--Importação Rodoviária - Rafael 12/09/2016	
Union All
		Select Num_Proc_LIO,@Status Status From LLP_Imp_Out LLP With(nolock) 
		Where 
			ATA_Lio is not null and Isnull(ID_STatus,0)<=2


--Sem Desembaraço - Cadu 13/05
		Union All
		Select LLP.Num_Proc Num_Proc,@Status Status From vwHouse_Imp LLP With(nolock) 
		Join Campo_Processo	CP With(nolock) on CP.num_proc=LLP.num_proc and Id_Campo=143		
		Where 
			ATA is not null and convert(Datetime, LLP.Dt_Emis,103) > '2020-01-01'
			and Campo_Dados in (2,3)  and Isnull(ID_STatus,0)<=2
			and left(LLP.num_proc,2) <> 'IO'
		Union All	
		Select LLP.Num_Proc Num_Proc,@Status Status From vwHouse_Exp LLP With(nolock) 
		Join Campo_Processo	CP With(nolock) on CP.num_proc=LLP.num_proc and Id_Campo=143		
		Where 
			ATA is not null and convert(Datetime, LLP.Dt_Emis,103) > '2020-01-01'
			and Campo_Dados in (2,3)  and Isnull(ID_STatus,0)<=2
			and left(LLP.num_proc,2) <> 'EO'
		

OPTION (HASH JOIN)
	End

If @ID_Status=4 
	Begin

--Importação Aérea Com Desembaraço
		Select Num_Proc_LIA Num_Proc,@Status Status From LLP_Imp_Aer LLP With(nolock) 
		Left Join Campo_Processo	CP With(nolock) on CP.num_proc=num_proc_lia and Id_Campo=32
		Join Tarefas_Processos		TP With(nolock) on TP.num_Proc=Num_Proc_LIA and Id_Task=4
		Where 
			(Campo_Dados=1 or Campo_Dados is null) and DT_Conclusao Is NOT Null
			And ATA_LIA >=getdate()-30
			and Isnull(ID_STatus,0)<=3

		Union ALL
--Importação Marítima Com Desembaraço
		

		Select Num_Proc_LIM,@Status Status From LLP_Imp_Mar LLP With(nolock)
		Left Join Campo_Processo	CP With(nolock) on CP.num_proc=num_proc_lim and Id_Campo=32
		Join Tarefas_Processos		TP With(nolock) on TP.num_Proc=Num_Proc_LIm and Id_Task=4
		Where 
			(Campo_Dados=1 or Campo_Dados is null) and DT_Conclusao Is NOT Null
			And ATA_LIm >=getdate()-90
			and Isnull(ID_STatus,0)<=3


--Sem Desembaraço
		Union All

		Select Num_Proc_LIA,@Status Status From LLP_Imp_Aer LLP With(nolock) 
		Join Campo_Processo	CP With(nolock) on CP.num_proc=num_proc_lia and Id_Campo=143
		Join Tarefas_Processos TP76 with(nolock) on TP76.Num_Proc = Num_proc_lia and TP76.ID_Task=76 and Dt_Conclusao is not null 
		Where Campo_Dados in (2,3)  and Isnull(ID_STatus,0)<=3


		Union All
		
		Select Num_Proc_LIM,@Status Status From LLP_Imp_Mar LLP With(nolock) 
		Join Campo_Processo	CP With(nolock) on CP.num_proc=num_proc_lim and Id_Campo=143
		Join Tarefas_Processos TP76 with(nolock) on TP76.Num_Proc = Num_proc_lim and TP76.ID_Task=76 and Dt_Conclusao is not null 
		Where Campo_Dados in (2,3) And Isnull(ID_STatus,0)<=3
		
		union all


		Select Num_Proc_LEA,@Status Status From LLP_exp_Aer LLP With(nolock) 
		Join Campo_Processo	CP With(nolock) on CP.num_proc=num_proc_lea and Id_Campo=143
		Join Tarefas_Processos TP76 with(nolock) on TP76.Num_Proc = Num_proc_lea and TP76.ID_Task=76 and Dt_Conclusao is not null 
		Where Campo_Dados in (2,3) and Isnull(ID_STatus,0)<=3


		Union All
		
		Select Num_Proc_LEM,@Status Status From LLP_exp_Mar LLP With(nolock) 
		Join Campo_Processo	CP With(nolock) on CP.num_proc=num_proc_lem and Id_Campo=143
		Join Tarefas_Processos TP76 with(nolock) on TP76.Num_Proc = Num_proc_lem and TP76.ID_Task=76 and Dt_Conclusao is not null 
		Where Campo_Dados in (2,3)  and Isnull(ID_STatus,0)<=3


		
		Union All

--Importação Rodoviária - Rafa 12/09/2016		
		Select Num_Proc_Lio,@Status Status From LLP_Imp_Out LLP With(nolock)
		Left Join Tarefas_Processos TP165 With(Nolock) on TP165.num_Proc= Num_Proc_Lio and TP165.Id_Task=165
		Left Join Tarefas_Processos TP7 With(Nolock) on TP7.num_Proc= Num_Proc_Lio and TP7.Id_Task=7
		Where 
			(TP165.DT_Conclusao Is NOT Null or TP7.DT_Conclusao Is NOT Null)
			and Isnull(ID_STatus,0)<=3	
		
		Union All		
--Exportacao - Cadu 02/02/2016
	--task: averbacao na exportacao mudar pra 4 faturamento		
	Select Num_Proc_Lem,@Status Status From LLP_Exp_Mar LLP With(nolock) 
		Join Tarefas_Processos TP With(Nolock) on TP.num_Proc=Num_Proc_Lem and TP.Id_Task=15
		Join Campo_Processo	CP With(nolock) on CP.num_proc=num_proc_lem and Id_Campo=143
	Where 
		TP.DT_Conclusao Is NOT Null and Campo_Dados in (1)
		and Isnull(ID_STatus,0)<=3
			
	Union All
	
	Select Num_Proc_Leo,@Status Status From LLP_Exp_Out LLP With(nolock) 
		Join Tarefas_Processos TP With(Nolock) on TP.num_Proc=Num_Proc_Leo and TP.Id_Task=15
	Where 
		TP.DT_Conclusao Is NOT Null
		and Isnull(ID_STatus,0)<=3
			
	Union All
	
	Select Num_Proc_Lea,@Status Status From LLP_Exp_Aer LLP With(nolock) 
		Join Tarefas_Processos TP With(Nolock) on TP.num_Proc=Num_Proc_Lea and TP.Id_Task=15
			Join Campo_Processo	CP With(nolock) on CP.num_proc=num_proc_lea and Id_Campo=143
	Where 
		TP.DT_Conclusao Is NOT Null
		and Isnull(ID_STatus,0)<=3	
		and Campo_Dados in (1)
		
OPTION (HASH JOIN)

	End
	
--Atualização para status 5 desativado.
--06-05-2014 - Rotina re-ativada por solicitação da Vivian chamado:30913
--if @Id_Status=5
--	Begin
--	--Aéreo Com Desembaraço
--		Select top 10 Num_Proc_LIA Num_Proc,@Status Status From LLP_Imp_Aer LLP With(nolock)
--		Join Net_Revenue_Temp N on LLP.Num_Proc_Lia = N.Ref_BDP 
--		Left Join Campo_Processo	CP With(Nolock) on CP.num_proc=num_proc_lia and Id_Campo=32
--		Join Tarefas_Processos		TP With(Nolock) on TP.num_Proc=Num_Proc_LIA and TP.Id_Task=4
--		Join Tarefas_Processos		TP40 With(Nolock) on TP40 .num_Proc=Num_Proc_LIA and TP40.Id_Task=40
--		Where 
--			(Campo_Dados=1 or Campo_Dados is null) and TP.DT_Conclusao Is NOT Null and
--			TP40.DT_Conclusao Is NOT Null And ATA_LIA >=getdate()-30
--			and Isnull(ID_STatus,0)<=4 and N.Net_revenue > 0--and dbo.FNetRevenueV2_Sel(Num_Proc_Lia)>0
			
--union all
--		Select  Num_Proc_LEA, @Status Status  From LLP_Exp_Aer LLP  With(Nolock)
--		Join Net_Revenue_Temp N on LLP.Num_Proc_Lea = N.Ref_BDP
--		Left Join Campo_Processo	CP With(Nolock) on CP.num_proc=num_proc_lea and Id_Campo=32
--		Join Tarefas_Processos		TP With(Nolock) on TP.num_Proc=Num_Proc_Lea and TP.Id_Task=4
--		Join Tarefas_Processos		TP40 With(Nolock) on TP40 .num_Proc=Num_Proc_Lea and TP40.Id_Task=40
--		Where 
--			(Campo_Dados=1 or Campo_Dados is null) and TP.DT_Conclusao Is NOT Null and
--			TP40.DT_Conclusao Is NOT Null And ATA_Lea >=getdate()-30 --or (ATD_Lea >= '2015-01-01' and SUBSTRING(Num_Proc_Lea,3,3) in ('CSR','STB')))
--			and Isnull(ID_STatus,0)<=4 and N.Net_revenue > 0--and dbo.FNetRevenueV2_Sel(Num_Proc_LiM)>0
			
--		Union ALL
----Marítima Com Desembaraço

--		Select top 10 Num_Proc_LIM,@Status Status From LLP_Imp_Mar LLP  With(Nolock)
--		Join Net_Revenue_Temp N on LLP.Num_Proc_Lim = N.Ref_BDP
--		Left Join Campo_Processo	CP With(Nolock) on CP.num_proc=num_proc_liM and Id_Campo=32
--		Join Tarefas_Processos		TP With(Nolock) on TP.num_Proc=Num_Proc_LIM and TP.Id_Task=4
--		Join Tarefas_Processos		TP40 With(Nolock) on TP40 .num_Proc=Num_Proc_LIM and TP40.Id_Task=40
--		Where 
--			(Campo_Dados=1 or Campo_Dados is null) and TP.DT_Conclusao Is NOT Null and
--			TP40.DT_Conclusao Is NOT Null And ATA_LIM >=getdate()-90
--			and Isnull(ID_STatus,0)<=4 and N.Net_revenue > 0--and dbo.FNetRevenueV2_Sel(Num_Proc_LiM)>0
--	union all

--		Select  Num_Proc_LEM, @Status Status  From LLP_Exp_Mar LLP  With(Nolock)
--		Join Net_Revenue_Temp N on LLP.Num_Proc_Lem = N.Ref_BDP
--		Left Join Campo_Processo	CP With(Nolock) on CP.num_proc=num_proc_leM and Id_Campo=32
--		Join Tarefas_Processos		TP With(Nolock) on TP.num_Proc=Num_Proc_LeM and TP.Id_Task=4
--		Join Tarefas_Processos		TP40 With(Nolock) on TP40 .num_Proc=Num_Proc_LeM and TP40.Id_Task=40
--		Where 
--			(Campo_Dados=1 or Campo_Dados is null) and TP.DT_Conclusao Is NOT Null and
--			TP40.DT_Conclusao Is NOT Null And ATA_LeM >=getdate()-90 --or (ATD_Lem >= '2015-01-01' and SUBSTRING(Num_Proc_Lem,3,3) in ('CSR','STB')))
--			and Isnull(ID_STatus,0)<=4 and N.Net_revenue > 0--and dbo.FNetRevenueV2_Sel(Num_Proc_LiM)>0
			
--		union all
		

----Processos sem Desembaraço

--		Select distinct top 10 Num_Proc_LIA,@Status Status From LLP_Imp_Aer LLP With(Nolock)
--		Join Net_Revenue_Temp N on LLP.Num_Proc_Lia = N.Ref_BDP
--		Left Join Campo_Processo	CP With(Nolock) on CP.num_proc=num_proc_lia and Id_Campo=32
--		Join vwcta_Cte 			CTA With(Nolock) on cta.num_proc_hia=num_proc_lia and cd_tp_Tx in (select cd_tp_tx from tipo_Taxa With(Nolock) where pft_aer='S')
--		Join vwcta_Cte 			CTN With(Nolock) on ctn.num_proc_hia=num_proc_liA and CTN.cd_tp_Tx in (select cd_tp_tx from tipo_Taxa With(Nolock) where pft_aer='N') and CTN.num_nf_hia is not null

--		Where 
--			(Campo_Dados=2 ) And ATA_LIA >=getdate()-30
--			and Isnull(ID_STatus,0)<=4 and N.Net_revenue > 0--and dbo.FNetRevenueV2_Sel(Num_Proc_Lia)>0
			
--		Union All
		
--		Select distinct top 10 Num_Proc_LIM,@Status Status From LLP_Imp_Mar LLP With(Nolock) 
--		Join Net_Revenue_Temp N on LLP.Num_Proc_Lim = N.Ref_BDP
--		Left Join Campo_Processo	CP With(Nolock) on CP.num_proc=num_proc_lim and Id_Campo=32
--		Join vwcta_Cte 				CTA With(Nolock) on cta.num_proc_hia=num_proc_lim and CTA.cd_tp_Tx in (select cd_tp_tx from tipo_Taxa With(Nolock) where pft_aer='S')
--		Join vwcta_Cte 				CTN With(Nolock) on ctN.num_proc_hia=num_proc_lim and CTN.cd_tp_Tx in (select cd_tp_tx from tipo_Taxa With(Nolock) where pft_aer='N') and CTN.num_nf_hia is not null

--		Where 
--			(Campo_Dados=2 )And ATA_LIM >=getdate()-30
--			and Isnull(ID_STatus,0)<=4 and N.Net_revenue > 0--and dbo.FNetRevenueV2_Sel(Num_Proc_Lim)>0


--		Union All
		
--		Select distinct top 10 Num_Proc_LEA,@Status Status From LLP_Exp_Aer LLP With(Nolock)
--		Join Net_Revenue_Temp N on LLP.Num_Proc_Lea = N.Ref_BDP
--		Left Join Campo_Processo	CP With(Nolock) on CP.num_proc=num_proc_lea and Id_Campo=32
--		Join vwcta_Cte 			CTA With(Nolock) on cta.num_proc_hia=num_proc_lea and cd_tp_Tx in (select cd_tp_tx from tipo_Taxa With(Nolock) where pft_aer='S')
--		Join vwcta_Cte 			CTN With(Nolock) on ctn.num_proc_hia=num_proc_lea and CTN.cd_tp_Tx in (select cd_tp_tx from tipo_Taxa With(Nolock) where pft_aer='N') and CTN.num_nf_hia is not null

--		Where 
--			(Campo_Dados=2 )And ATA_LEA >=getdate()-30
--			and Isnull(ID_STatus,0)<=4 and N.Net_revenue > 0--and dbo.FNetRevenueV2_Sel(Num_Proc_Lia)>0
	
--		Union All
		
--		Select distinct top 10 Num_Proc_LEM,@Status Status From LLP_exp_Mar LLP With(Nolock) 
--		Join Net_Revenue_Temp N on LLP.Num_Proc_Lem = N.Ref_BDP
--		Left Join Campo_Processo	CP With(Nolock) on CP.num_proc=num_proc_lem and Id_Campo=32
--		Join vwcta_Cte 				CTA With(Nolock) on cta.num_proc_hia=num_proc_lem and CTA.cd_tp_Tx in (select cd_tp_tx from tipo_Taxa With(Nolock) where pft_aer='S')
--		Join vwcta_Cte 				CTN With(Nolock) on ctN.num_proc_hia=num_proc_lem and CTN.cd_tp_Tx in (select cd_tp_tx from tipo_Taxa With(Nolock) where pft_aer='N') and CTN.num_nf_hia is not null

--		Where 
--			(Campo_Dados=2 )And ATA_LeM >=getdate()-30
--			and Isnull(ID_STatus,0)<=4 and N.Net_revenue > 0--and dbo.FNetRevenueV2_Sel(Num_Proc_Lem)>0

--OPTION (HASH JOIN)
--	End

if @Id_Status=5
	--Status – 05 – Processo Encerrado
	--- O Status 5 - Processo Encerrado deverá ser de uso exclusivo de auditoria/qualidade, 
	--após fechamento do Task de auditoria se houver ou manualmente com esse Status.
	--1 – o Task: Auditoria de Processos Management, foi criado dia 17/06/2015
	--Todos os JOBS de todos os Modais  com BDP Produto = CHB + Freight Forward, 
	--Task: Auditoria = Preenchido, 
	--e o Status vazio ou menor ou igual a 04 - Faturamento
	BEGIN
		Select LLP.Num_Proc Num_Proc,@Status Status From vwClienteALLJOBS LLP With(nolock)		
			Join Tarefas_Processos	TP With(Nolock) on TP.num_Proc=LLP.Num_Proc and TP.Id_Task=154	
			--left join Tipo_Status_Processo T on T.ID_Status = LLP.id_status	
		Where 		
			TP.DT_Conclusao Is NOT Null
			and (Isnull(LLP.ID_STatus,0)<=4 or LLP.id_status = 8) 
			
	OPTION (HASH JOIN)
	END


if @Id_Status=8
--- Após preenchimento do Task "Faturamento Criado" ou "Envio da Prestação de Contas" 
--o ATL deverá encerrar os JOBs (Todos Modais CHB e CHB + FF) 
--A Regra ficará assim:
--Jobs com BDP Produto = CHB + Freight Forward, Task prenchido: Faturamento Criado ou Envio da Prestação de Contas
-- e o Status vazio ou menor que 04 – Nacionalização
	BEGIN
		Select LLP.Num_Proc Num_Proc,@Status Status From vwClienteALLJOBS LLP With(nolock)
			Join Campo_Processo		CP With(Nolock) on CP.num_proc=LLP.Num_Proc and Id_Campo=143
			join BDP_Produto		B With(Nolock) on B.ID_PD = CP.Campo_Dados
			left Join Tarefas_Processos	TP40 With(Nolock) on TP40.num_Proc=LLP.Num_Proc and TP40.Id_Task=40
			left Join Tarefas_Processos	TP76 With(Nolock) on TP76.num_Proc=LLP.Num_Proc and TP76.Id_Task=76	
			left join Log_Status LO With(Nolock) on LLP.Num_Proc = LO.num_proc and LO.ID_status = 8			
		Where 
			(Campo_Dados=1 or Campo_Dados = 3) 	
			and (TP40.DT_Conclusao Is Not Null  or TP76.DT_Conclusao Is Not Null)		
			and Isnull(LLP.ID_STatus,0)<=4
			--and LO.dt_ins < GETDATE()- 2
			and LO.num_proc is null
			and left(LLP.Num_Proc,2) <> 'BO'
			
	
	UNION ALL
--2 - Regras de Agenciamento propostas pelo Agenciamento para encerramento dos processos:
--- Importação: ATA + 7 dias corridos e Exportação: ATD + 15.
--A regra ficará assim:
-- - Importação:
--Todos os JOBS de todos os Modais  de Importação com BDP Produto = Freight Forward, Task: Auditoria = Preenchido, 
--ATA preenchido com data menor que Hoje – 7 dias 
--e o Status vazio ou menor ou igual a 04 – Faturamento
--100-60479  - Solicitado para alteração de 30 dias
		Select LLP.Num_Proc Num_Proc,@Status Status From vwClienteALLJOBS LLP With(nolock)
			Join Campo_Processo		CP With(Nolock) on CP.num_proc=LLP.Num_Proc and Id_Campo=143
			left Join Tarefas_Processos	TP76 With(Nolock) on TP76.num_Proc=LLP.Num_Proc and TP76.Id_Task=76
			left Join Tarefas_Processos	TP78 With(Nolock) on TP78.num_Proc=LLP.Num_Proc and TP78.Id_Task=78
			Join Tarefas_Processos	TP261 With(Nolock) on TP261.num_Proc=LLP.Num_Proc and TP261.Id_Task=261 and TP261.Dt_Conclusao is not null 
			left join Log_Status LO With(Nolock) on LLP.Num_Proc = LO.num_proc and LO.ID_status = 8	
		Where 
			(Campo_Dados in (2,3)) 		
			and (TP78.DT_Conclusao Is Not Null  or TP76.DT_Conclusao Is Not Null)
			and (Isnull(LLP.ID_STatus,0)<=4)
			and LO.num_proc is null		 --cadu/ 14/12 - 19hs

---8/20/2020 - Disabled FreightForwarder logic adding 2=1
	UNION ALL
--- Exportação:
--Todos os JOBS de todos os Modais  de Importação com BDP Produto = Freight Forward, 
--Task: Auditoria = Preenchido, ATD preenchido com data menor que Hoje – 15 dias 
--e o Status vazio ou menor ou igual a 04 – Faturamento
--100-60479  - Solicitado para alteração de 30 dias
		Select LLP.Num_Proc Num_Proc,@Status Status From vwClienteALLJOBS LLP With(nolock)
			Join Campo_Processo		CP With(Nolock) on CP.num_proc=LLP.Num_Proc and Id_Campo=143
			left Join Tarefas_Processos	TP76 With(Nolock) on TP76.num_Proc=LLP.Num_Proc and TP76.Id_Task=76
			left Join Tarefas_Processos	TP78 With(Nolock) on TP78.num_Proc=LLP.Num_Proc and TP78.Id_Task=78
			left join Log_Status LO With(Nolock) on LLP.Num_Proc = LO.num_proc and LO.ID_status = 8	
			Join Tarefas_Processos	TP261 With(Nolock) on TP261.num_Proc=LLP.Num_Proc and TP261.Id_Task=261 and TP261.Dt_Conclusao is not null
		Where 
			(Campo_Dados=2) 		
			and (TP78.DT_Conclusao Is Not Null  or TP76.DT_Conclusao Is Not Null)
			--And LLP.ATD >= getdate()-10 
			And LLP.ATD <= getdate()-365
			and (Isnull(LLP.ID_STatus,0)<=4)--	or LLP.id_status = 8) 		
			and LEFT(LLP.num_proc, 1) = 'E'
			and LO.num_proc is null
			
		UNION ALL
		----jobs da regra de 48hs, contando apartir da data do ultimo de encerramento.
			Select LLP.Num_Proc Num_Proc,@Status Status From vwClienteALLJOBS LLP With(nolock)
				join Log_Status LO With(Nolock) on LLP.Num_Proc = LO.num_proc
			where
				LLP.ID_STatus<=4	
				and LO.ID_status = 8
				and LO.dt_ins < GETDATE() - 2
				and left(LLP.Num_Proc,2) <> 'BO' 
				---8/20/2020 - Disabled FreightForwarder logic adding 2=1
	OPTION (HASH JOIN)	
	END	





GO
