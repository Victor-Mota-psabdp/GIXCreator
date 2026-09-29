SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spLivro_Contabil_Item_InsUpd]
(
	@ID int,
	@Item int,
	@Job varchar(16),
	@Historico varchar(500),
	@Historico2	varchar(500),
	@Valor float,
	@ContaCredito varchar(50),
	@ContaDebito varchar(50),
	@Cd_Usuario varchar(50)
)
As

	if @Item is null or @Item = ''
		begin
			set @item = (select isnull(max(item),0) +1 from Livro_Contabil_Item where id=@ID)
		end

	If exists(select ID from Livro_Contabil_Item where id=@ID and item=@Item)
		Begin
			Update
				Livro_Contabil_Item
			set
				Job = @Job,
				Historico = @Historico,
				Historico2 = @Historico2,
				Valor = @Valor,
				ContaCredito = @ContaCredito,
				ContaDebito = @ContaDebito,
				Cd_Usuario = @Cd_Usuario,
				Last_UPD = getdate()
			where
				id = @ID and item = @Item
		End
	Else
		Begin
			insert into Livro_Contabil_Item 
				(ID, Item, Job, Historico, Historico2, Valor, ContaCredito, ContaDebito, Cd_Usuario, Last_UPD)
			Values
				(@ID,@Item,@Job,@Historico,@Historico2,@Valor,@ContaCredito,@ContaDebito,@Cd_Usuario,getdate())
		End
GO
