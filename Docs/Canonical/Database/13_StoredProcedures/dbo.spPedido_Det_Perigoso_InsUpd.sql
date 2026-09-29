SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--cadu 06/05/2021 - coloquei o mesmo q estava em testes
--spPedido_Det_Perigoso_InsUpd '333920','CANGUARDTM ULTRA BIT 20 DPG PRESERVATIVE','029409','30','1760','',
--'IVO, N.E. (1,2-Benzisotiazolin-3-ona, Hidr#xido de s#dio), 8, II 1H1/Y1.8/250/','','','','','','','' 
--sp_help Pedido_Det_Perigoso
--spPedido_Det_Perigoso_InsUpd '318775','CANGUARDTM ULTRA BIT 20 DPG PRESERVATIVE','007645','20','1760','',
--'OSIVO, N.E. (1,2-Benzisotiazolin-3-ona, Hidr#xido de s#dio), 8, II 1H1/Y1.8/250/',
--'','','','','','','' 
----select len('OSIVO, N.E. (1,2-Benzisotiazolin-3-ona, Hidr#xido de s#dio), 8, II 1H1/Y1.8/250/')
--select CHARINDEX('(','OSIVO, N.E. (1,2-Benzisotiazolin-3-ona, Hidr#xido de s#dio), 8, II 1H1/Y1.8/250/')> 0 - 13
--select 
--substring('OSIVO, N.E. (1,2-Benzisotiazolin-3-ona, Hidr#xido de s#dio), 8, II 1H1/Y1.8/250/',29,abs(-16))
--13-29)
--select 13-29
--Select Cd_Grupo from Pedido where cd_pedido='318775'1
--select cd_prod from produto_cliente where produto_descr='CANGUARDTM ULTRA BIT 20 DPG PRESERVATIVE' and Cd_Cliente='1'
--select cd_prod from produto_cliente where cd_prod=73720
--Cadu 19/04/2021 - cadu inclui o esqueam do charindex - nao sei onde usa os valores
CREATE Procedure [dbo].[spPedido_Det_Perigoso_InsUpd] 
(
	@Cd_Pedido			Int,
	@Nome_Produto		VarChar(500),
	@Lote				VarChar(30),
	@Item				Varchar(6),	
	@HAZMAT_CD			Varchar(7),
	@HAZMAT_CLASS_CD	Varchar(4),
	@HAZMAT_DESC		Varchar(300),
	@HAZMAT_CONTACT		Varchar(24),
	@HAZMAT_PAGE		Varchar(6),
	@HAZMAT_FPOINT		Varchar(3),
	@HAZMAT_FPOINT_CD	Varchar(2),
	@HAZMAT_PULL_DESC_FRM_BDP	Varchar(1),
	@HAZMAT_ORG_DESC	Varchar(1),
	@HAZMAT_DESC_QUAL	Varchar(3)
)
as

BEGIN TRANSACTION

	Declare @cd_produto Int
	Declare @Cd_Grupo varchar(10)
	
	Set @Cd_Grupo = (Select Cd_Grupo from Pedido where cd_pedido=@cd_pedido)
	
	Set @Cd_Produto=(select cd_prod from produto_cliente where produto_descr=@nome_produto and Cd_Cliente=@Cd_Grupo)
	if @Cd_Produto is NULL or @Cd_Produto = ''
		begin
			Set @Cd_Produto=(select cd_prod from produto_cliente where cd_proc_cliente=@nome_produto and Cd_Cliente=@Cd_Grupo)
		end
		
--Ajusta ITEM qdo FMC ou Consagro
	if @cd_grupo in ('362','P16997')
		begin
			set @Item = right(@Item,5)
		end	

	IF NOT EXISTS(SELECT CD_PEDIDO FROM Pedido_Det_Perigoso Where cd_pedido=@cd_pedido 
								and item=@item and lote=@lote and Cd_Produto=@Cd_Produto)
		BEGIN
			INSERT INTO
				Pedido_Det_Perigoso
					(
					Cd_Pedido,Cd_Produto,Lote,Item,
					HAZMAT_CD,HAZMAT_CLASS_CD,HAZMAT_DESC,HAZMAT_CONTACT,HAZMAT_PAGE,HAZMAT_FPOINT,
					HAZMAT_FPOINT_CD,HAZMAT_PULL_DESC_FRM_BDP,HAZMAT_ORG_DESC,HAZMAT_DESC_QUAL		
					)
			VALUES
					(
					@Cd_Pedido,@Cd_Produto,@Lote,@Item,
					@HAZMAT_CD,@HAZMAT_CLASS_CD,@HAZMAT_DESC,@HAZMAT_CONTACT,@HAZMAT_PAGE,
					@HAZMAT_FPOINT,@HAZMAT_FPOINT_CD,@HAZMAT_PULL_DESC_FRM_BDP,@HAZMAT_ORG_DESC,
					@HAZMAT_DESC_QUAL
					) 
		END

	ELSE
		BEGIN
			UPDATE	
				Pedido_Det_Perigoso
			SET					
				HAZMAT_CD = @HAZMAT_CD,
				HAZMAT_CLASS_CD= @HAZMAT_CLASS_CD,
				HAZMAT_DESC= @HAZMAT_DESC,
				HAZMAT_CONTACT= @HAZMAT_CONTACT,
				HAZMAT_PAGE= @HAZMAT_PAGE,
				HAZMAT_FPOINT= @HAZMAT_FPOINT,
				HAZMAT_FPOINT_CD= @HAZMAT_FPOINT_CD,
				HAZMAT_PULL_DESC_FRM_BDP= @HAZMAT_PULL_DESC_FRM_BDP,
				HAZMAT_ORG_DESC= @HAZMAT_ORG_DESC,
				HAZMAT_DESC_QUAL= @HAZMAT_DESC_QUAL
			WHERE
				Cd_Pedido=@Cd_Pedido and Item=@Item and lote=@lote and Cd_Produto=@Cd_Produto
		END
		
	IF EXISTS(select cd_prod from produto_cliente where cd_prod=@Cd_Produto)
		Begin
				Declare @HazMat_Description varchar(300)
				Declare @EMS_MFAG_NUMBERS varchar(50)
				Declare @CharIndex int
				set @charIndex = (select CHARINDEX('(',@HAZMAT_DESC))
				print @charIndex
				Declare @CharIndexSsubstring int
				set @CharIndexSsubstring = (select abs(@charIndex -29))
				print @CharIndexSsubstring
				--if CHARINDEX('(',@HAZMAT_DESC)> 0
				--	begin
				--		set	@HazMat_Description =	substring(@HAZMAT_DESC,29,CHARINDEX('(',@HAZMAT_DESC)-29)
				--	end
				if CHARINDEX('(',@HAZMAT_DESC)> 0
					begin
						set	@HazMat_Description = substring(@HAZMAT_DESC,29,@CharIndexSsubstring)
					end
				print @HazMat_Description
				print CHARINDEX('Stowage',@HAZMAT_DESC)
				if CHARINDEX('Stowage',@HAZMAT_DESC) >0
					Begin
						set	@EMS_MFAG_NUMBERS = left(right(rtrim(left(@HAZMAT_DESC, CHARINDEX('Stowage',@HAZMAT_DESC)-1)),9),8) 
					End
				print @EMS_MFAG_NUMBERS
			IF NOT EXISTS(SELECT Cd_Prod FROM Produto_Perigoso Where cd_prod=@Cd_Produto)
				Begin					
					INSERT INTO
						Produto_Perigoso
						(
							cd_prod,
							uncode,
							classCode,
							HazMat_Name_Material,
							HazMat_Description,
							HazMat_Contact,
							HazMat_Phone,
							FlashPoint,
							measureCode,
							packingCode,
							EMS_MFAG_NUMBERS
						)
					Values
						(
							@Cd_Produto,
							@HAZMAT_CD,
							@HAZMAT_CLASS_CD,
							@HazMat_Description,
							@HAZMAT_DESC,
							NULL,
							@HAZMAT_CONTACT,
							@HAZMAT_FPOINT,
							@HAZMAT_FPOINT_CD,
							NULL,
							@EMS_MFAG_NUMBERS
						)
					End
				else
					Begin
						update
							 Produto_Perigoso
						set
							uncode = @HAZMAT_CD,
							classCode = @HAZMAT_CLASS_CD,
							HazMat_Name_Material = @HazMat_Description,
							HazMat_Description = @HAZMAT_DESC,
							HazMat_Contact = NULL,
							HazMat_Phone = @HAZMAT_CONTACT,
							FlashPoint = @HAZMAT_FPOINT,
							measureCode = @HAZMAT_FPOINT_CD,
							packingCode = Null,
							EMS_MFAG_NUMBERS = @EMS_MFAG_NUMBERS
						where Cd_Prod = @Cd_Produto
					End
			End
-- F-E, S-E,		
--F-E, S-E,	
--select left(right(rtrim(left(HAZMAT_DESC, CHARINDEX('Stowage',HAZMAT_DESC)-1)),9),8) ,CHARINDEX(', Stowage',HAZMAT_DESC)-1,HAZMAT_DESC,
----substring(HAZMAT_DESC,29,CHARINDEX('(',HAZMAT_DESC)-29),
----CHARINDEX(', Stowage',HAZMAT_DESC)-8,
----CHARINDEX('(',HAZMAT_DESC)-29,

--* from 	Pedido_Det_Perigoso
--where CHARINDEX('(',HAZMAT_DESC)> 0	and CHARINDEX('Stowage',HAZMAT_DESC) > 0		
		
		
	IF @@ERROR <> 0 
		BEGIN
			ROLLBACK TRANSACTION
			RETURN -2
		END

COMMIT TRANSACTION




----spPedido_Det_Perigoso_InsUpd '255504','Mancozeb Technical-273246 (273246) (273246) (273246) (273246)','669941','10','3265','8','HAZARDOUS GOODS INFO UN3077 ENVIRONMENTALLY HAZARDOUS SUBSTANCE, SOLID, N.O.S. (Mancozeb),9, III Colombia UN3077 ENVIRONMENTALLY HAZARDOUS SUBSTANCE,SOLID, N.O.S. (Mancozeb), 9,III, Marine pollutant IMDG UN3077 ENVIRONMENTALLY HAZARDOUSSUBSTANCE, SOLID, N.O.S. (Mancozeb), 9, III, Marine pollutant, F','1-888-862-7770','','','','','','U' 
--ALTER Procedure [dbo].[spPedido_Det_Perigoso_InsUpd] 
--	@Cd_Pedido			Int,
--	@Nome_Produto		VarChar(500),
--	@Lote				VarChar(30),
--	@Item				Varchar(6),	
--	@HAZMAT_CD			Varchar(7),
--	@HAZMAT_CLASS_CD	Varchar(4),
--	@HAZMAT_DESC		Varchar(300),
--	@HAZMAT_CONTACT		Varchar(24),
--	@HAZMAT_PAGE		Varchar(6),
--	@HAZMAT_FPOINT		Varchar(3),
--	@HAZMAT_FPOINT_CD	Varchar(2),
--	@HAZMAT_PULL_DESC_FRM_BDP	Varchar(1),
--	@HAZMAT_ORG_DESC	Varchar(1),
--	@HAZMAT_DESC_QUAL	Varchar(3)
--as

--BEGIN TRANSACTION

--	Declare @cd_produto Int
--	Declare @Cd_Grupo varchar(10)
	
--	Set @Cd_Grupo = (Select Cd_Grupo from Pedido where cd_pedido=@cd_pedido)
	
--	Set @Cd_Produto=(select cd_prod from produto_cliente where produto_descr=@nome_produto and Cd_Cliente=@Cd_Grupo)
--	if @Cd_Produto is NULL or @Cd_Produto = ''
--		begin
--			Set @Cd_Produto=(select cd_prod from produto_cliente where cd_proc_cliente=@nome_produto and Cd_Cliente=@Cd_Grupo)
--		end
		
----Ajusta ITEM qdo FMC ou Consagro
--	if @cd_grupo in ('362','P16997')
--		begin
--			set @Item = right(@Item,5)
--		end	

--	IF NOT EXISTS(SELECT CD_PEDIDO FROM Pedido_Det_Perigoso Where cd_pedido=@cd_pedido 
--								and item=@item and lote=@lote and Cd_Produto=@Cd_Produto)
--		BEGIN
--			INSERT INTO
--				Pedido_Det_Perigoso
--					(
--					Cd_Pedido,Cd_Produto,Lote,Item,
--					HAZMAT_CD,HAZMAT_CLASS_CD,HAZMAT_DESC,HAZMAT_CONTACT,HAZMAT_PAGE,HAZMAT_FPOINT,
--					HAZMAT_FPOINT_CD,HAZMAT_PULL_DESC_FRM_BDP,HAZMAT_ORG_DESC,HAZMAT_DESC_QUAL		
--					)
--			VALUES
--					(
--					@Cd_Pedido,@Cd_Produto,@Lote,@Item,
--					@HAZMAT_CD,@HAZMAT_CLASS_CD,@HAZMAT_DESC,@HAZMAT_CONTACT,@HAZMAT_PAGE,
--					@HAZMAT_FPOINT,@HAZMAT_FPOINT_CD,@HAZMAT_PULL_DESC_FRM_BDP,@HAZMAT_ORG_DESC,
--					@HAZMAT_DESC_QUAL
--					) 
--		END

--	ELSE
--		BEGIN
--			UPDATE	
--				Pedido_Det_Perigoso
--			SET					
--				HAZMAT_CD = @HAZMAT_CD,
--				HAZMAT_CLASS_CD= @HAZMAT_CLASS_CD,
--				HAZMAT_DESC= @HAZMAT_DESC,
--				HAZMAT_CONTACT= @HAZMAT_CONTACT,
--				HAZMAT_PAGE= @HAZMAT_PAGE,
--				HAZMAT_FPOINT= @HAZMAT_FPOINT,
--				HAZMAT_FPOINT_CD= @HAZMAT_FPOINT_CD,
--				HAZMAT_PULL_DESC_FRM_BDP= @HAZMAT_PULL_DESC_FRM_BDP,
--				HAZMAT_ORG_DESC= @HAZMAT_ORG_DESC,
--				HAZMAT_DESC_QUAL= @HAZMAT_DESC_QUAL
--			WHERE
--				Cd_Pedido=@Cd_Pedido and Item=@Item and lote=@lote and Cd_Produto=@Cd_Produto
--		END
		
--	IF EXISTS(select cd_prod from produto_cliente where cd_prod=@Cd_Produto)
--		Begin
--				Declare @HazMat_Description varchar(200)
--				Declare @EMS_MFAG_NUMBERS varchar(50)
--				if CHARINDEX('(',@HAZMAT_DESC)> 0
--					begin
--						set	@HazMat_Description =	substring(@HAZMAT_DESC,29,CHARINDEX('(',@HAZMAT_DESC)-29)
--					end
--				print @HazMat_Description
--				print CHARINDEX('Stowage',@HAZMAT_DESC)
--				if CHARINDEX('Stowage',@HAZMAT_DESC) >0
--					Begin
--						set	@EMS_MFAG_NUMBERS = left(right(rtrim(left(@HAZMAT_DESC, CHARINDEX('Stowage',@HAZMAT_DESC)-1)),9),8) 
--					End
--				print @EMS_MFAG_NUMBERS
--			IF NOT EXISTS(SELECT Cd_Prod FROM Produto_Perigoso Where cd_prod=@Cd_Produto)
--				Begin				
--					INSERT INTO
--						Produto_Perigoso
--						(
--							cd_prod,
--							uncode,
--							classCode,
--							HazMat_Name_Material,
--							HazMat_Description,
--							HazMat_Contact,
--							HazMat_Phone,
--							FlashPoint,
--							measureCode,
--							packingCode,
--							EMS_MFAG_NUMBERS
--						)
--					Values
--						(
--							@Cd_Produto,
--							@HAZMAT_CD,
--							@HAZMAT_CLASS_CD,
--							@HazMat_Description,
--							@HAZMAT_DESC,
--							NULL,
--							@HAZMAT_CONTACT,
--							@HAZMAT_FPOINT,
--							@HAZMAT_FPOINT_CD,
--							NULL,
--							@EMS_MFAG_NUMBERS
--						)
--					End
--				else
--					Begin
--						update
--							 Produto_Perigoso
--						set
--							uncode = @HAZMAT_CD,
--							classCode = @HAZMAT_CLASS_CD,
--							HazMat_Name_Material = @HazMat_Description,
--							HazMat_Description = @HAZMAT_DESC,
--							HazMat_Contact = NULL,
--							HazMat_Phone = @HAZMAT_CONTACT,
--							FlashPoint = @HAZMAT_FPOINT,
--							measureCode = @HAZMAT_FPOINT_CD,
--							packingCode = Null,
--							EMS_MFAG_NUMBERS = @EMS_MFAG_NUMBERS
--						where Cd_Prod = @Cd_Produto
--					End
--			End
---- F-E, S-E,		
----F-E, S-E,	
----select left(right(rtrim(left(HAZMAT_DESC, CHARINDEX('Stowage',HAZMAT_DESC)-1)),9),8) ,CHARINDEX(', Stowage',HAZMAT_DESC)-1,HAZMAT_DESC,
------substring(HAZMAT_DESC,29,CHARINDEX('(',HAZMAT_DESC)-29),
------CHARINDEX(', Stowage',HAZMAT_DESC)-8,
------CHARINDEX('(',HAZMAT_DESC)-29,

----* from 	Pedido_Det_Perigoso
----where CHARINDEX('(',HAZMAT_DESC)> 0	and CHARINDEX('Stowage',HAZMAT_DESC) > 0		
		
		
--	IF @@ERROR <> 0 
--		BEGIN
--			ROLLBACK TRANSACTION
--			RETURN -2
--		END

--COMMIT TRANSACTION
GO
