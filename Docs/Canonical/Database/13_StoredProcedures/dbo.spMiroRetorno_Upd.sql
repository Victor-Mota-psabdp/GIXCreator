SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE Procedure [dbo].[spMiroRetorno_Upd]
	(

		@Ordem varchar(10),
		@Item	Varchar(5),
		@Mensagem varchar(60)
)

as
Begin
	Update fmc_miro
			Set 
				Mensagem_Retorno=@Mensagem,
				Dt_Retorno=Getdate()
	where
		Fatura_Pc
			in
				(
				select num_proc Job from pedido_ship PS
				Join Pedido PD on PD.cd_pedido=PS.cd_pedido
				where
					num_pedido=right('0000' + @Ordem,10)
					and item=right('0000' + @Item,5)
				)
			and id_evento='I'
			and Mensagem_Retorno is null
			and dt_retorno is null
			and Status='E'
End


GO
