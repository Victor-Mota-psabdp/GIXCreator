SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--alter table [dbo].[Pedido_Container] add [DT_Ins] Datetime NULL
CREATE procedure [dbo].[spATL_Pedido_Container_InsUpd](
	@Cd_Pedido	int,
	@Num_Cont	varchar(15),
	@Num_Lacre	varchar(50),
	@Peso_Bruto_VGM	float,
	@UOM_VGM	varchar(2),
	@Nome_Responsavel_VGM	varchar(100),
	@Dt_Envio_VGM	datetime,
	@Metodo_VGM	varchar(1)
)
as
BEGIN TRANSACTION

IF NOT EXISTS(SELECT CD_PEDIDO FROM Pedido_Container Where CD_PEDIDO = @CD_PEDIDO and Num_Cont = @Num_Cont)
	Begin
		Insert Pedido_Container(
			Cd_Pedido,
			Num_Cont,
			Num_Lacre,
			Peso_Bruto_VGM,
			UOM_VGM,
			Nome_Responsavel_VGM,
			Dt_Envio_VGM,
			Metodo_VGM,
			DT_Ins
			)
		Values(
			@Cd_Pedido,
			@Num_Cont,
			@Num_Lacre,
			@Peso_Bruto_VGM,
			@UOM_VGM,
			@Nome_Responsavel_VGM,
			@Dt_Envio_VGM,
			@Metodo_VGM,
			GETDATE()
		)
	End
else
	Begin
		Update Pedido_Container set 
			Num_Lacre=@Num_Lacre,
			Peso_Bruto_VGM=@Peso_Bruto_VGM,
			UOM_VGM=@UOM_VGM,
			Nome_Responsavel_VGM=@Nome_Responsavel_VGM,
			Dt_Envio_VGM=@Dt_Envio_VGM,
			Metodo_VGM=@Metodo_VGM
		where @Cd_Pedido = Cd_Pedido and Num_Cont =@Num_Cont
	End
	
	BEGIN
		Declare @Num_Proc as Varchar(16)
		set @Num_Proc = (select top 1 Num_Proc from Pedido_Ship where cd_pedido = @cd_pedido)
		if @Num_Proc is not null
			begin		
				exec spATL_Pedido_Container_Atualiza_InsUpd @Num_Proc,@cd_pedido,'ATL'
			end
	END
	

	--IF @@ERROR <> 0 
	--	BEGIN
	--		ROLLBACK TRANSACTION
	--		RETURN -2
	--	END

COMMIT TRANSACTION
GO
