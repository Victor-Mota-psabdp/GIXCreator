SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--spAPAY_Adiantamento_Sel '2018-07-23','2018-07-23','CSR'
--select * from vwcta_Cte where Num_Proc_HIA like 'IOCSR201807%'

CREATE Procedure [dbo].[spAPAY_Adiantamento_Sel]
(
	@DataInicial	as Datetime,
	@DataFinal		as Datetime,
	@Grupo			as varchar(3)
	
)
As	
	select	
		distinct CC.num_proc_hia Referencia, CX.num_proc_hia  
	from vwcta_Cte CC 
		Left join vwCXAS CX on CC.num_proc_hia = CX.Num_proc_hia and CC.Cd_tp_tx = CX.Cd_tp_tx and CX.dc_hia = 'C' 
		join vwClienteALLJOBS HOU on CC.Num_proc_hia = HOU.Num_Proc		
		join pessoa	CNS with(nolock) on CNS.cd_pes = HOU.cd_cliente
		Left Outer Join Pessoa_LLP  PLL	with(nolock) on HOU.cd_cliente = PLL.Cd_Pes
		Left Outer Join Grupo		G	with(nolock) on G.cd_pes_grupo=PLL.cd_pes_grupo
		--Left Outer Join pessoa		PG	with(nolock) on PG.cd_pes=PLL.Cd_Pes_Grupo			 
	where 
		CX.Num_proc_hia is Null 
		and CC.cd_tp_tx like 'XB%' 
		and CC.dc_hia = 'C'
		and convert(date,cc.Dt_Ins_HIA,103) between convert(date,@DataInicial)  and convert(date,@DataFinal)
		and G.Grupo = @Grupo
 order by 1 
GO
