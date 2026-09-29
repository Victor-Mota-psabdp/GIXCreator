SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure spTotal_Imp_Ano_Rel --'1','%AFRMM%'
(
@Grupo as varchar(3),
@Taxa as varchar(30)
)
As
	select
		left(right(isnull(P.Planta,PLL.Cd_Planta) ,4),2) Cia, sum(vlr_item_custo) Valor  --,Nome_Tp_Tx,CC.Num_Proc, Dt_Conclusao,PLL.Cd_Pes_Grupo
	from
		custo_cliente CC
		Left Join House_Imp_Mar HIM on HIM.Num_Proc_HIM=CC.Num_Proc
		Left Join House_Imp_Aer HIA on HIA.Num_Proc_HIA=CC.Num_Proc
		Left Join House_Imp_Out HIO on HIO.Num_Proc_HIO=CC.Num_Proc
		join tipo_taxa TT on TT.cd_tp_tx=CC.cd_tp_tx
		Join Pedido_Ship PS on PS.Num_Proc=CC.Num_Proc 
		Join Pedido P on P.Cd_Pedido=PS.Cd_Pedido
		Join Tarefas_Processos TP on TP.Num_Proc=CC.Num_Proc and Id_Task=4 and Dt_Conclusao between '2008-01-01' and '2008-12-31'
		Join Pessoa_LLP PLL on (PLL.Cd_Pes=HIM.Cd_Consig_HIM or PLL.Cd_Pes=HIA.Cd_Consig_HIA or PLL.Cd_Pes=HIO.Cd_Consig_HIO) and PLL.Cd_Pes_Grupo=(select cd_Pes_Grupo from Grupo where Grupo=@Grupo) 
	where
		Nome_Tp_Tx like @Taxa
		and (Prestacao='S' or Prestacao is null)
	group by 
		left(right(isnull(P.Planta,PLL.Cd_Planta) ,4),2)  --,Nome_Tp_Tx, CC.Num_Proc, Dt_Conclusao,PLL.Cd_Pes_Grupo
	order by
		Cia --CC.Num_Proc
GO
