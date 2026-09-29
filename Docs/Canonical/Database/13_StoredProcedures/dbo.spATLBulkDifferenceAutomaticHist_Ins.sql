SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spATLBulkDifferenceAutomaticHist_Ins]

as

Declare @Num_Proc Varchar(16)
Declare @Apelido	Varchar(25)
Declare @historico Varchar(500)
Declare @DataHistorico datetime


Declare Cur_Alert cursor for 
	select 
		vwh.num_proc,CNSG.Apelido,
		'BDP Job:' + vwH.Num_Proc + '-' + 'PO:' + PO.Numero_PO + '  -  ' + 'DI:' + PO.Numero_DI +
		
	    ' Peso Liquido: ' + cast(cast(vwh.Peso_Liquido as Decimal(20,2)) as varchar(40)) +   
	    ' Quantidade Descarregada:' + cast(cast(CP.Campo_Dados as Decimal(20,2)) as varchar(40)) +  
		' Diferença: ' + cast(cast((cast(cp.Campo_Dados as float)/vwh.Peso_Liquido -1) as float)*100 as varchaR(100)) + '%' [Historico],
		getdate() DataHistorico

	
	from 
		vwHouse_IMP vwH
		left join vwPO_IMP PO with(nolock) on  vwH.Num_proc = PO.Num_proc
		join Pessoa CNSG with(nolock) on vwH.Cd_Consig=CNSG.Cd_Pes
		left join Tarefas_Processos TP4 with(nolock) on vwH.Num_proc = TP4.Num_Proc and TP4.ID_Task = 4
		Join Pessoa_LLP PLL  with(nolock) on PLL.Cd_Pes=vwH.Cd_Consig
		join Grupo G with(nolock) on G.cd_pes_grupo=PLL.cd_pes_grupo
		join pessoa	PG  with(nolock) on PG.cd_pes=PLL.Cd_Pes_Grupo
		Left Join Campo_Processo CP with(nolock) on vwH.Num_Proc = CP.Num_Proc and CP.Id_Campo=37 and ISNUMERIC(cp.Campo_Dados)=1 
		left Join Tipo_carga TC on TC.Cd_Tp_Carga=vwh.Tp_Carga
		Left Join Hist_Geral H with(nolock) on vwH.Num_Proc=h.HSGProcesso and H.Cd_Tp_Ocor=118
	
	where  
		H.HSGProcesso is null  and (cast((cast(cp.Campo_Dados as float)/vwh.Peso_Liquido -1) as float)*100)>1
		and TP4.Dt_Conclusao >=getdate()-30
		and G.Grupo in ('LYB')
		
open Cur_Alert
	
	Fetch Next From Cur_Alert Into @Num_Proc,@Apelido,@historico,@DataHistorico
	While @@FETCH_STATUS = 0
		Begin
			Print 'Executando stored'
			exec spHistG_InsUPD  @Num_Proc,null,@Apelido,'Divergencia de Peso DI vs BL',@historico,@DataHistorico,null,'ATL System','N','U',null 
			Print 'End'
		Fetch Next From Cur_Alert Into @Num_Proc,@Apelido,@historico,@DataHistorico
		end
	close Cur_Alert

	deallocate Cur_Alert 
		
GO
