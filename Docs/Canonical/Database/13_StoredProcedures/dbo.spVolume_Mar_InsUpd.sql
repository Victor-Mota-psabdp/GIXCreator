SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spVolume_Mar_InsUpd]
(
	@Num_Proc		varchar(16),
	@Item 			varchar(2),
	@Qtd_Vol		Float, 
	@Compr			Float,
	@Largura		Float,
	@Altura			Float,
	@Vol_Item		Float,
	@NCM			varchar(8),
	@Peso_Bruto		Float,
	@Nome_Tp_Embal	varchar(30),	
	@Marca			varchar(2000),
	@Contra_Marca	varchar(2000),	
	@Num_Cont		varchar(15)
)

AS

BEGIN TRANSACTION

Declare @cd_tp_embal varchar(3)
Declare @Id_NCM		 int
Declare @Item_Cont   varchar(10)

IF upper(LEFT(@Num_Proc,2)) = 'IM'
	BEGIN
		set @Item_Cont = (select CH.Item_Cont_IM from Container_Hou_Imp_Mar CH
							Join Container_Mas_Imp_Mar MAS on MAS.Num_Proc_MIM = CH.Num_Proc_MIM and MAS.Item_Cont_IM = CH.Item_Cont_IM
							where CH.num_proc_him = @Num_Proc and MAS.Num_Cont_IM = @Num_Cont)

		set @cd_tp_embal = (select cd_tp_embal from tipo_embalagem where Nome_Tp_Embal = @Nome_Tp_Embal)
		set @Id_NCM = (select id_ncm from NCM where ncm = @NCM)

		if EXISTS (select Item_IM from Volume_Imp_Mar where Item_IM = @Item and Num_Proc_HIM = @Num_Proc)
			BEGIN
				UPDATE
					Volume_Imp_Mar
				SET
					Qtd_Vol_IM	=@Qtd_Vol,
					Cd_Tp_Embal	=@Cd_Tp_Embal,
					Compr_IM	=@Compr,
					Largura_IM	=@Largura,
					Altura_IM	=@Altura,
					Peso_Bruto_IM	=@Peso_Bruto,
					Id_NCM		=@Id_NCM,
					Marca_IM	=@Marca,
					Contra_Marca =@Contra_Marca,
					Vol_Item_IM	=@Vol_Item,
					cd_tp_unidade	='M3',
					Item_Cont_IM = @Item_Cont
				WHERE
					Item_IM = @Item and Num_Proc_HIM = @Num_Proc
			END
		ELSE
			BEGIN
				SET @Item=(select Isnull(max(Item_IM),0)+1 from Volume_Imp_Mar where Num_Proc_HIM=@Num_Proc)
				SET @Item = right(@Item,2)
				INSERT INTO
					Volume_Imp_Mar
					(
						Num_Proc_HIM,Item_IM,Qtd_Vol_IM,Cd_Tp_Embal,Compr_IM,Largura_IM,Altura_IM,
						Peso_Bruto_IM,Id_NCM,Marca_IM,Contra_Marca,Vol_Item_IM,cd_tp_unidade,Item_Cont_IM
					)
				VALUES
					(
						@Num_Proc,@Item,@Qtd_Vol,@Cd_Tp_Embal,@Compr,@Largura,@Altura,
						@Peso_Bruto,@Id_NCM,@Marca,@Contra_Marca,@Vol_Item,'M3',@Item_Cont
					)
			END
	END
	
ELSE IF upper(LEFT(@Num_Proc,2)) = 'EM'
	BEGIN
		set @Item_Cont= (select CH.Item_Cont_EM from Container_Hou_Exp_Mar CH
						Join Container_Mas_Exp_Mar MAS on MAS.Num_Proc_MEM = CH.Num_Proc_MEM and MAS.Item_Cont_EM = CH.Item_Cont_EM
						where CH.num_proc_hEm = @Num_Proc and MAS.Num_Cont_EM = @Num_Cont)
 
		set @cd_tp_embal = (select cd_tp_embal from tipo_embalagem where Nome_Tp_Embal = @Nome_Tp_Embal)
		set @Id_NCM = (select id_ncm from NCM where ncm = @NCM)

		if exists (select Item_EM from Volume_Exp_Mar where Item_EM = @Item and Num_Proc_HEM = @Num_Proc)
			BEGIN
				UPDATE
					Volume_Exp_Mar
				SET
					Qtd_Vol_EM	=@Qtd_Vol,
					Cd_Tp_Embal	=@Cd_Tp_Embal,
					Compr_EM	=@Compr,
					Largura_EM	=@Largura,
					Altura_EM	=@Altura,
					Peso_Bruto_EM	=@Peso_Bruto,
					Id_NCM		=@Id_NCM,
					Marca_EM	=@Marca,
					Contra_Marca	=@Contra_Marca,
					Vol_Item_EM	=@Vol_Item,
					cd_tp_unidade	='M3',
					Item_Cont_EM = @Item_Cont
				WHERE
					Item_EM = @Item and Num_Proc_HEM = @Num_Proc
			END
		ELSE
			BEGIN
				SET @Item=(select Isnull(max(Item_EM),0)+1 from Volume_Exp_Mar where Num_Proc_HEM=@Num_Proc )
				SET @Item = '0'+@Item
				SET @Item = right(@Item,2)
				INSERT INTO
					Volume_Exp_Mar
					(Num_Proc_HEM,Item_EM,Qtd_Vol_EM,Cd_Tp_Embal,Compr_EM,Largura_EM,Altura_EM,Peso_Bruto_EM,
						Id_NCM,Marca_EM,Contra_Marca,Vol_Item_EM,cd_tp_unidade,Item_Cont_EM
					)
				VALUES
					(@Num_Proc,@Item,@Qtd_Vol,@Cd_Tp_Embal,@Compr,@Largura,@Altura,	@Peso_Bruto,
						@Id_NCM,@Marca,@Contra_Marca,@Vol_Item,'M3',@Item_Cont
					)
			END	
	END 

	

IF @@Error <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN -1
	END

COMMIT TRANSACTION
	






GO
