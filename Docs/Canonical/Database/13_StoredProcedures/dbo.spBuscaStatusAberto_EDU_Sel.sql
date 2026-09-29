SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spBuscaStatusAberto_EDU_Sel]--8
		@ID_Status int

AS

Declare @Status Varchar(50)
Set @Status= (select cast(ID_Status as varchar(3)) + ' - ' + Status_Descricao from tipo_status_processo With(nolock) where id_status=@id_status)

If @ID_Status=1 
	Begin
		select Num_Proc_LiA Num_Proc,@Status Status from llp_imp_Aer With(nolock) where atd_lia is null and id_status is null
		
		Union All

		select Num_Proc_LiM Num_Proc,@Status Status from llp_imp_Mar With(nolock) where atd_lim is null and id_status is null

		Union All

		select Num_Proc_Lio Num_Proc,@Status Status from llp_imp_Out With(nolock) where atd_lio is null and id_status is null

		Union All

		select Num_Proc_LEA Num_Proc,@Status Status from llp_Exp_Aer With(nolock) where atd_lea is null and id_status is null

		Union All

		select Num_Proc_LEM Num_Proc,@Status Status from llp_Exp_Mar With(nolock) where atd_lem is null and id_status is null

		Union All

		Select Num_Proc_LEO Num_Proc,@Status Status From LLP_Exp_Out With(nolock) Where ATD_LEO is null and id_status is null
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

		Union ALL
--Importação Marítima
		

		Select Num_Proc_LIM,@Status Status From LLP_Imp_Mar LLP With(nolock) 
		Left Join Campo_Processo	CP With(nolock) on CP.num_proc=num_proc_lim and Id_Campo=32
		Join Tarefas_Processos		TP With(nolock) on TP.num_Proc=Num_Proc_LIm and Id_Task=4
		Where 
			(Campo_Dados=1 or Campo_Dados is null) and DT_Conclusao Is Null
			And ATA_LIm >=getdate()-30
			and Isnull(ID_STatus,0)<=2
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
		Left Join Campo_Processo	CP With(nolock) on CP.num_proc=num_proc_lia and Id_Campo=32
		Where Campo_Dados=2 And ATA_LIA >=getdate()-30 and Isnull(ID_STatus,0)<=3


		Union All
		
		Select Num_Proc_LIM,@Status Status From LLP_Imp_Mar LLP With(nolock)
		Left Join Campo_Processo	CP With(nolock) on CP.num_proc=num_proc_lim and Id_Campo=32
		Where Campo_Dados=2 And ATA_LIM >=getdate()-30 and Isnull(ID_STatus,0)<=3
		
		Union All
		
--Exportacao - Cadu 02/02/2016
	--task: averbacao na exportacao mudar pra 4 faturamento		
	Select Num_Proc_Lem,@Status Status From LLP_Exp_Mar LLP With(nolock) 
		Join Tarefas_Processos TP With(Nolock) on TP.num_Proc=Num_Proc_Lem and TP.Id_Task=15
	Where 
		TP.DT_Conclusao Is NOT Null
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
	Where 
		TP.DT_Conclusao Is NOT Null
		and Isnull(ID_STatus,0)<=3	
	
		
OPTION (HASH JOIN)

	End


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
		left join Tipo_Status_Processo T on T.ID_Status = LLP.id_status	
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
		Select LLP.Num_Proc Num_Proc,@Status Status 		
		From vwClienteALLJOBS LLP With(nolock)
			Join Campo_Processo		CP With(Nolock) on CP.num_proc=LLP.Num_Proc and Id_Campo=143
			join BDP_Produto		B With(Nolock) on B.ID_PD = CP.Campo_Dados
			left Join Tarefas_Processos	TP40 With(Nolock) on TP40.num_Proc=LLP.Num_Proc and TP40.Id_Task=40
			left Join Tarefas_Processos	TP76 With(Nolock) on TP76.num_Proc=LLP.Num_Proc and TP76.Id_Task=76	
			--left join Log_Status LO With(Nolock) on LO.num_proc = LLP.Num_Proc and LO.ID_status = 8
			
		Where 
			(Campo_Dados=1 or Campo_Dados = 3) 	
			and (TP40.DT_Conclusao Is Not Null  or TP76.DT_Conclusao Is Not Null)		
			and Isnull(LLP.ID_STatus,0)<=4
			--and LO.dt_ins < GETDATE()- 2
			
			
	UNION ALL
--2 - Regras de Agenciamento propostas pelo Agenciamento para encerramento dos processos:
--- Importação: ATA + 7 dias corridos e Exportação: ATD + 15.
--A regra ficará assim:
-- - Importação:
--Todos os JOBS de todos os Modais  de Importação com BDP Produto = Freight Forward, Task: Auditoria = Preenchido, 
--ATA preenchido com data menor que Hoje – 7 dias 
--e o Status vazio ou menor ou igual a 04 – Faturamento
	Select LLP.Num_Proc Num_Proc,@Status Status From vwClienteALLJOBS LLP With(nolock)
		Join Campo_Processo		CP With(Nolock) on CP.num_proc=LLP.Num_Proc and Id_Campo=143
		left Join Tarefas_Processos	TP76 With(Nolock) on TP76.num_Proc=LLP.Num_Proc and TP76.Id_Task=76
		left Join Tarefas_Processos	TP78 With(Nolock) on TP78.num_Proc=LLP.Num_Proc and TP78.Id_Task=78
		--left join Log_Status LO With(Nolock) on LO.num_proc = LLP.Num_Proc and LO.ID_status = 8	
	Where 
		(Campo_Dados=2) 		
		and (TP78.DT_Conclusao Is Not Null  or TP76.DT_Conclusao Is Not Null)
		--And LLP.ATA >=getdate()-7
		And LLP.ATA <=getdate()-15		
		and (Isnull(LLP.ID_STatus,0)<=4)	
		and LEFT(LLP.num_proc, 1) = 'I'

UNION ALL
--- Exportação:
--Todos os JOBS de todos os Modais  de Importação com BDP Produto = Freight Forward, 
--Task: Auditoria = Preenchido, ATD preenchido com data menor que Hoje – 15 dias 
--e o Status vazio ou menor ou igual a 04 – Faturamento
	Select LLP.Num_Proc Num_Proc,@Status Status From vwClienteALLJOBS LLP With(nolock)
		Join Campo_Processo		CP With(Nolock) on CP.num_proc=LLP.Num_Proc and Id_Campo=143
		left Join Tarefas_Processos	TP76 With(Nolock) on TP76.num_Proc=LLP.Num_Proc and TP76.Id_Task=76
		left Join Tarefas_Processos	TP78 With(Nolock) on TP78.num_Proc=LLP.Num_Proc and TP78.Id_Task=78
		--left join Log_Status LO With(Nolock) on LO.num_proc = LLP.Num_Proc and LO.ID_status = 8	
	Where 
		(Campo_Dados=2) 		
		and (TP78.DT_Conclusao Is Not Null  or TP76.DT_Conclusao Is Not Null)
		--And LLP.ATD >= getdate()-10 
		And LLP.ATD <= getdate()-15
		and (Isnull(LLP.ID_STatus,0)<=4)--	or LLP.id_status = 8) 		
		and LEFT(LLP.num_proc, 1) = 'E'	
	
	END
	






















--Regra Antiga
--Atualização para status 5 desativado.
--06-05-2014 - Rotina re-ativada por solicitação da Vivian chamado:30913
--if @Id_Status=5
--	Begin
--		Select top 10 Num_Proc_LIA Num_Proc,@Status Status From LLP_Imp_Aer LLP With(nolock)
--		Left Join Campo_Processo	CP With(Nolock) on CP.num_proc=num_proc_lia and Id_Campo=32
--		Join Tarefas_Processos		TP With(Nolock) on TP.num_Proc=Num_Proc_LIA and TP.Id_Task=4
--		Join Tarefas_Processos		TP40 With(Nolock) on TP40 .num_Proc=Num_Proc_LIA and TP40.Id_Task=40
--		Where 
--			(Campo_Dados=1 or Campo_Dados is null) and TP.DT_Conclusao Is NOT Null and
--			TP40.DT_Conclusao Is NOT Null And ATA_LIA >=getdate()-30
--			and Isnull(ID_STatus,0)<=4 and dbo.FNetRevenue_Sel(Num_Proc_Lia)>0

--		Union ALL
----Importação Marítima Com Desembaraço


--		Select top 10 Num_Proc_LIM,@Status Status From LLP_Imp_Mar LLP  With(Nolock)
--		Left Join Campo_Processo	CP With(Nolock) on CP.num_proc=num_proc_liM and Id_Campo=32
--		Join Tarefas_Processos		TP With(Nolock) on TP.num_Proc=Num_Proc_LIM and TP.Id_Task=4
--		Join Tarefas_Processos		TP40 With(Nolock) on TP40 .num_Proc=Num_Proc_LIM and TP40.Id_Task=40
--		Where 
--			(Campo_Dados=1 or Campo_Dados is null) and TP.DT_Conclusao Is NOT Null and
--			TP40.DT_Conclusao Is NOT Null And ATA_LIM >=getdate()-90
--			and Isnull(ID_STatus,0)<=4 and dbo.FNetRevenue_Sel(Num_Proc_LiM)>0

----Processos sem Desembaraço
--		Union All

--		Select distinct top 10 Num_Proc_LIA,@Status Status From LLP_Imp_Aer LLP With(Nolock)
--		Left Join Campo_Processo	CP With(Nolock) on CP.num_proc=num_proc_lia and Id_Campo=32
--		Join vwcta_Cte 			CTA With(Nolock) on cta.num_proc_hia=num_proc_lia and cd_tp_Tx in (select cd_tp_tx from tipo_Taxa where pft_aer='S')
--		Join vwcta_Cte 			CTN With(Nolock) on ctn.num_proc_hia=num_proc_liA and CTN.cd_tp_Tx in (select cd_tp_tx from tipo_Taxa where pft_aer='N') and CTN.num_nf_hia is not null

--		Where 
--			(Campo_Dados=2 )And ATA_LIA >=getdate()-30
--			and Isnull(ID_STatus,0)<=4 and dbo.FNetRevenue_Sel(Num_Proc_Lia)>0
	

--		Union All
		
--		Select distinct top 10 Num_Proc_LIM,@Status Status From LLP_Imp_Mar LLP With(Nolock) 
--		Left Join Campo_Processo	CP With(Nolock) on CP.num_proc=num_proc_lim and Id_Campo=32
--		Join vwcta_Cte 				CTA With(Nolock) on cta.num_proc_hia=num_proc_lim and CTA.cd_tp_Tx in (select cd_tp_tx from tipo_Taxa where pft_aer='S')
--		Join vwcta_Cte 				CTN With(Nolock) on ctN.num_proc_hia=num_proc_lim and CTN.cd_tp_Tx in (select cd_tp_tx from tipo_Taxa where pft_aer='N') and CTN.num_nf_hia is not null

--		Where 
--			(Campo_Dados=2 )And ATA_LIM >=getdate()-30
--			and Isnull(ID_STatus,0)<=4 and dbo.FNetRevenue_Sel(Num_Proc_Lim)>0


--		Union All
		
--		Select distinct top 10 Num_Proc_LEM,@Status Status From LLP_exp_Mar LLP With(Nolock) 
--		Left Join Campo_Processo	CP With(Nolock) on CP.num_proc=num_proc_lem and Id_Campo=32
--		Join vwcta_Cte 				CTA With(Nolock) on cta.num_proc_hia=num_proc_lem and CTA.cd_tp_Tx in (select cd_tp_tx from tipo_Taxa where pft_aer='S')
--		Join vwcta_Cte 				CTN With(Nolock) on ctN.num_proc_hia=num_proc_lem and CTN.cd_tp_Tx in (select cd_tp_tx from tipo_Taxa where pft_aer='N') and CTN.num_nf_hia is not null

--		Where 
--			(Campo_Dados=2 )And ATA_LeM >=getdate()-30
--			and Isnull(ID_STatus,0)<=4 and dbo.FNetRevenue_Sel(Num_Proc_Lem)>0

--OPTION (HASH JOIN)
--	End









GO
