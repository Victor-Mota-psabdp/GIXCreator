SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE	procedure [dbo].[spATL_Volume_Imp_Mar_InsUpd]
			
	@Num_Proc    	varchar(16),
	@Item       	varchar(2),
	@Qtd_Vol	    Float, 
	@Embalagem	    varchar(30),
	@Comprimento	Float,
	@Largura	    Float,
	@Altura	        Float,
	@Peso_Bruto	    Float,
	@NCM		    varchar(8),
	@Marca	        varchar(2000),
	@Contra_Marca	varchar(2000),
	@Volume		    Float,
	@Container      varchar(15)

AS

BEGIN TRANSACTION

Declare @cd_tp_embal 	varchar(3)
Declare @Id_NCM		int
Declare @Item_Cont_IM varchar(10)

	set @Item_Cont_IM = (select CH.Item_Cont_IM from Container_Hou_Imp_Mar CH
						Join Container_Mas_Imp_Mar MAS on MAS.Num_Proc_MIM = CH.Num_Proc_MIM and MAS.Item_Cont_IM = CH.Item_Cont_IM
						where CH.num_proc_him = @Num_Proc and MAS.Num_Cont_IM = @Container)

	set @cd_tp_embal = (select cd_tp_embal from tipo_embalagem where nome_tp_embal = @Embalagem)
	set @Id_NCM = (select id_ncm from NCM where ncm = @NCM)

	if exists (select Item_IM from Volume_Imp_Mar where Item_IM = @Item and Num_Proc_HIM = @Num_Proc)
		BEGIN
			UPDATE
				Volume_Imp_Mar
			SET
				Qtd_Vol_IM	  =@Qtd_Vol,
				Cd_Tp_Embal   =@cd_tp_embal,
				Compr_IM	  =@Comprimento,
				Largura_IM	  =@Largura,
				Altura_IM	  =@Altura,
				Peso_Bruto_IM =@Peso_Bruto,
				Id_NCM		  =@Id_NCM,
				Marca_IM	  =@Marca,
				Contra_Marca  =@Contra_Marca,
				Vol_Item_IM	  =@Volume,
				cd_tp_unidade ='M3',
				Item_Cont_IM  = @Item_Cont_IM
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
					Num_Proc_HIM,
					Item_IM,
					Qtd_Vol_IM,
					Cd_Tp_Embal,
					Compr_IM,
					Largura_IM,
					Altura_IM,
					Peso_Bruto_IM,
					Id_NCM,
					Marca_IM,
					Contra_Marca,
					Vol_Item_IM,
					cd_tp_unidade,
					Item_Cont_IM
				)
			VALUES
				(
					@Num_Proc,
					@Item,
					@Qtd_Vol,
					@Cd_Tp_Embal,
					@Comprimento,
					@Largura,
					@Altura,
					@Peso_Bruto,
					@Id_NCM,
					@Marca,
					@Contra_Marca,
					@Volume,
					'M3',
					@Item_Cont_IM
				)
		END

IF @@Error <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN -1
	END

COMMIT TRANSACTION
	






GO
