SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE Procedure [dbo].[spATL_PedidoXJOB_Rel]
(
	@Grupo varchar(20),
	@Dt_Inicial	datetime,
	@Dt_Final	datetime
)
As
	declare @cd_pes_grupo varchar(10)
	Set @cd_pes_grupo = (select top 1 Cd_Pes from pessoa where apelido=@Grupo)

	select
		Num_Pedido [Número do Pedido], Dt_Pedido [Data do Pedido], num_proc [Nº do JOB]
	from
		pedido P
		left join pedido_ship PS on PS.cd_pedido=P.cd_pedido
	where
		cd_grupo=@cd_pes_grupo and Dt_Pedido between @Dt_Inicial and @Dt_Final
	order by
		Dt_Pedido




GO
