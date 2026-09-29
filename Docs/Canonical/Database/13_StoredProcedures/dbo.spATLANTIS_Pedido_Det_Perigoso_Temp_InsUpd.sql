SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Pedido_Det_Perigoso_Temp
CREATE Procedure [dbo].[spATLANTIS_Pedido_Det_Perigoso_Temp_InsUpd]
(
		@ID					bigint,
		@Cd_Pedido			varchar(200),
		@Cd_Produto			varchar(200),
		@Name_Produto		varchar(200),
		@Item				varchar(200),
		@Lote				varchar(200),	
		@HAZMAT_CD	varchar(200),
		@HAZMAT_CLASS_CD	varchar(200),
		@HAZMAT_DESC	varchar(200),
		@HAZMAT_CONTACT	varchar(200),
		@HAZMAT_PAGE	varchar(200),
		@HAZMAT_FPOINT	varchar(200),
		@HAZMAT_FPOINT_CD	varchar(200),
		@HAZMAT_PULL_DESC_FRM_BDP	varchar(200),
		@HAZMAT_ORG_DESC	varchar(200),
		@HAZMAT_DESC_QUAL	varchar(200),	
		@ID_House_Temp		varchar(200),
		@ID_Req				varchar(200),
		@Intl_Reference		varchar(200)
)

as


BEGIN
--Exceção(try/CATCH)
--Transação
--sp_help Pedido_Det_Temp_New
	BEGIN TRY
		if @Item is null	
				begin
					set @Item=(SELECT Isnull(max(Item),0)+1  FROM Pedido_Det_Perigoso_Temp with(nolock) Where ID=@ID) 
				end	

		IF NOT EXISTS(SELECT ID FROM Pedido_Det_Perigoso_Temp with(nolock) Where ID=@ID and Item = @Item)		
			BEGIN				
				insert into Pedido_Det_Perigoso_Temp
					(
						ID,cd_pedido,cd_produto,Name_Produto,Item,Lote,
						HAZMAT_CD,HAZMAT_CLASS_CD,HAZMAT_DESC,HAZMAT_CONTACT,HAZMAT_PAGE,HAZMAT_FPOINT,
						HAZMAT_FPOINT_CD,HAZMAT_PULL_DESC_FRM_BDP,HAZMAT_ORG_DESC,HAZMAT_DESC_QUAL,
						ID_House_Temp,ID_Req,Intl_Reference									
					)
				VALUES
					(
						@ID,@cd_pedido,@cd_produto,@Name_Produto,@Item,@Lote,
						@HAZMAT_CD,@HAZMAT_CLASS_CD,@HAZMAT_DESC,@HAZMAT_CONTACT,@HAZMAT_PAGE,@HAZMAT_FPOINT,
						@HAZMAT_FPOINT_CD,@HAZMAT_PULL_DESC_FRM_BDP,@HAZMAT_ORG_DESC,@HAZMAT_DESC_QUAL,
						@ID_House_Temp,@ID_Req,@Intl_Reference
					)
			END
		ELSE
			BEGIN
				UPDATE 
					Pedido_Det_Perigoso_Temp 
				SET	
					cd_pedido=@cd_pedido,
					cd_produto=@cd_produto,
					Name_Produto=@Name_Produto,					
					Lote=@Lote,
					
					HAZMAT_CD=@HAZMAT_CD,
					HAZMAT_CLASS_CD=@HAZMAT_CLASS_CD,
					HAZMAT_DESC=@HAZMAT_DESC,
					HAZMAT_CONTACT=@HAZMAT_CONTACT,
					HAZMAT_PAGE=@HAZMAT_PAGE,
					HAZMAT_FPOINT=@HAZMAT_FPOINT,
					HAZMAT_FPOINT_CD=@HAZMAT_FPOINT_CD,
					HAZMAT_PULL_DESC_FRM_BDP=@HAZMAT_PULL_DESC_FRM_BDP,
					HAZMAT_ORG_DESC=@HAZMAT_ORG_DESC,
					HAZMAT_DESC_QUAL=@HAZMAT_DESC_QUAL,

					ID_House_Temp=@ID_House_Temp,
					ID_Req=@ID_Req,
					Intl_Reference=@Intl_Reference
				WHERE
					ID=@ID and Item= @Item
			END

		Select @ID as Retorno;
		
		COMMIT TRAN
	END TRY

	BEGIN CATCH
		ROLLBACK TRAN
		SELECT ERROR_MESSAGE() as Retorno;

	END CATCH	

END

















GO
