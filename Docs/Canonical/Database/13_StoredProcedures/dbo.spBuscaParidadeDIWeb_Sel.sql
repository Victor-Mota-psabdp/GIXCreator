SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create Procedure [dbo].[spBuscaParidadeDIWeb_Sel]
		@Grupo varchar(3)
as

Declare  @TableTemp TABLE
(
	Num_Doc varchar(50),
	Data_DC datetime,
	Num_Proc varchar(16)
)
Insert Into @TableTemp
Exec[spPODOCWeb_Sel] '5','FMC'

select distinct Temp.Num_proc,Num_Doc, Campo_Dados from campo_processo CP
Join Pedido_Ship PS on PS.num_proc=CP.num_proc
Join Pedido PD on PD.cd_pedido=Ps.cd_pedido
Join @TableTemp Temp on PS.Num_proc = Temp.Num_proc
where 
	id_campo=31
GO
