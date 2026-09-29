SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_CampoOrdem_Ins_Upd]
(
	@Cd_Pedido int,
	@Id_Campo	int,
	@Campo_Dados varchar(500),
	@Cd_Usuario	varchar(50)
)
AS
Begin Transaction 
	if exists(Select * from Campo_Ordem With(Nolock) where Cd_Pedido = @Cd_Pedido and Id_Campo = @Id_Campo)
		Begin
			Update
				Campo_Ordem
			Set
				Campo_Dados = @Campo_Dados,
				Cd_Usuario = @Cd_Usuario,
				Dt_Ins_Upd = GETDATE()
			where Cd_Pedido = @Cd_Pedido and Id_Campo = @Id_Campo
		End
	ELSE
		Begin
		if @Campo_Dados <> '' and @Campo_Dados is not null
			Begin
				insert 
					Campo_Ordem
				(
					Cd_Pedido,
					Id_Campo,
					Campo_Dados,
					Cd_Usuario,
					Dt_Ins_Upd
				)
				values
				(
					@Cd_Pedido,
					@Id_Campo,
					@Campo_Dados,
					@Cd_Usuario,
					getdate()
				)
			End
		End
		IF @@Error <> 0
			BEGIN
				ROLLBACK TRANSACTION
				RETURN -1
			END
Commit Transaction 

GO
