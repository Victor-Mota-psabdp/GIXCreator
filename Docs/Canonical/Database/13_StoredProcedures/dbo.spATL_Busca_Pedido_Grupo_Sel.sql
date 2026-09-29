SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spATL_Busca_Pedido_Grupo_Sel] 
(
	@Num_Pedido	varchar(30),
	@Grupo varchar	(20)
)
as
select PS.cd_pedido from Pedido PD
    join pedido_ship PS on PD.cd_pedido = PS.cd_Pedido
    join Pessoa P on PD.Cd_Grupo = p.cd_pes
	join Grupo GR on P.cd_pes = GR.Cd_Pes_Grupo
where 
	PD.Num_Pedido = @Num_Pedido 
	and P.Apelido = @Grupo
	

	
	



GO
