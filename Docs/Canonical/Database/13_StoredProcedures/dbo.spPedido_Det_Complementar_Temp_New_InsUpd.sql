SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Pedido_Det_Complementar_Temp_New  
CREATE Procedure [dbo].[spPedido_Det_Complementar_Temp_New_InsUpd] 
(	
	@ID					bigint,
	@Cd_Pedido			varchar(200),
	@Cd_Produto			varchar(200),
	@Name_Produto		varchar(200),
	@Item				varchar(200),
	@Lote				varchar(200),	
	@cd_usuario			varchar(200),
	@Cd_Pes_Fabricante	varchar(200),
	@Name_Pes_Fabricante	varchar(200),
	@Cd_Pais_Fabricante	varchar(200),
	@Name_Pais_Fabricante	varchar(200),
	@Vlr_FOB	varchar(200),
	@ID_TP_AC			varchar(200),
	@Name_AC			varchar(200)	
)

as

BEGIN TRANSACTION

	if @Item is null
	begin
		set @Item=(SELECT Isnull(max(Item),0)+1  FROM Pedido_Det_Complementar_Temp_New Where ID=@ID) 
	end	

	IF NOT EXISTS(SELECT ID FROM Pedido_Det_Complementar_Temp_New  Where ID=@ID and Item = @Item)
		BEGIN	
				
			INSERT INTO
				Pedido_Det_Complementar_Temp_New 
					(	ID,cd_pedido,cd_produto,Name_Produto,Item,Lote,cd_usuario,Dt_ins,Cd_Pes_Fabricante,
					Name_Pes_Fabricante,Cd_Pais_Fabricante,Name_Pais_Fabricante,Vlr_FOB,ID_TP_AC,Name_AC
					)
			VALUES
					(
						@ID,@cd_pedido,@cd_produto,@Name_Produto,@Item,@Lote,@cd_usuario,GETDATE(),@Cd_Pes_Fabricante,
						@Name_Pes_Fabricante,@Cd_Pais_Fabricante,@Name_Pais_Fabricante,@Vlr_FOB,@ID_TP_AC,@Name_AC

					) 
		END

	ELSE
		BEGIN
			UPDATE Pedido_Det_Complementar_Temp_New 
				SET					
					--ID=@ID,
					cd_pedido=@cd_pedido,
					cd_produto=@cd_produto,
					Name_Produto=@Name_Produto,
					--Item=@Item,
					Lote=@Lote,
					cd_usuario=@cd_usuario,
					Dt_ins=getdate(),
					Cd_Pes_Fabricante=@Cd_Pes_Fabricante,
					Name_Pes_Fabricante=@Name_Pes_Fabricante,
					Cd_Pais_Fabricante=@Cd_Pais_Fabricante,
					Name_Pais_Fabricante=@Name_Pais_Fabricante,
					Vlr_FOB=@Vlr_FOB,
					ID_TP_AC=@ID_TP_AC,
					Name_AC=@Name_AC
			WHERE
				ID=@ID and Item= @Item
				--Cd_Pedido=@Cd_Pedido and Item=@Item 
				--and lote=@lote and Cd_Produto=@Cd_Produto
		END
	IF @@ERROR <> 0 
		BEGIN
			ROLLBACK TRANSACTION
			RETURN -2
		END

COMMIT TRANSACTION

GO
