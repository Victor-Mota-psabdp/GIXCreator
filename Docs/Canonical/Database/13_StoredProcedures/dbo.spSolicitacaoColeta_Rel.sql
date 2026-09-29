SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure spSolicitacaoColeta_Rel
	
	@Processo varchar (16)

As

select 
	NS.Numero_Po_Hem	Num_Solicitacao,
	SC.Dt_Conclusao		Solic_Coleta,
	TP.Apelido			Transportadora,
	P.Num_Pedido		Ref_Exportador, 
	JOB. Nr_Reserva		Booking,
	ORG.Nome_local		Origem,
	(DST.Nome_Local + ' - ' + Pais.Nome_Pais) Destino,
	Hou.Navio_Hem		Navio,
	RCV.Apelido			Retirada_Container,
	JOB.Obs_Jem			OBS,
	LC.Apelido			Local_Coleta,
	LLP.PO_Req_Date		Dt_Necessidade,
	(PC.Produto_Descr + ' / ' + PD.Requision + ' / ' +  PD.Finalidade + ' / PB. ' + convert(varchar,PD.Peso_Bruto_TOT, 25))	Produtos,
	TER.Nome_Terminal	Des_Carga
from 
	LLP_exp_mar LLP
	left Outer Join Pessoa				TP		on LLP.Cd_Transportadora = TP.Cd_pes
	Left Outer Join Pedido_Ship			PS		on LLP.Num_Proc_Lem = PS.Num_proc
	Join			Pedido				P		on PS.Cd_Pedido = P.Cd_Pedido-- and PS.Item = P.Item and Ps.Lote = P.Lote
	Join			Job_Exp_Mar			JOB		on LLP.Num_Proc_Lem = JOB.Num_Proc_hem 
	Join			House_Exp_Mar		HOU		on LLP.Num_Proc_Lem = HOU.Num_Proc_Hem 
	Join			Localidade			ORG		on HOU.Cd_Org_Hem = ORG.CD_Local
	Join			Localidade			DST		on HOU.Cd_Dst_Hem = DST.Cd_Local
	Join			Pais				PAIS	on DST.Cd_Pais	= Pais.Cd_Pais
	Join			Pessoa				RCV		on JOB.Cd_Retirada_Vazios = RCV.Cd_Pes	
	Join			Pessoa				LC		on JOB.Cd_Pes_Crg = LC.Cd_pes
	Left Outer Join Tarefas_Processos	SC		on LLP.Num_Proc_Lem = SC.Num_Proc and ID_Task = 31
	Join			Produto_cliente		PC		on PS.Cd_produto = PC.Cd_Prod
	Join			Pedido_Det			PD		on PS.Cd_Pedido = PD.Cd_Pedido and PS.Item = PD.Item and PS.Lote = PD.Lote
	Join			Terminal			TER		on LLP.Cd_Terminal = TER.Cd_Terminal
	Left Outer Join	PO_HEM				NS		on LLP.Num_proc_Lem = NS.Num_proc_hem and ID_DC = 39

where 
	num_proc_lem = @Processo



GO
