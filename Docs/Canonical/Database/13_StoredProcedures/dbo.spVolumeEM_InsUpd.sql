SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--alter table Volume_Exp_Mar alter column Marca_EM varchar(2000)
--alter table Volume_Exp_Mar alter column Contra_Marca varchar(2000)

CREATE	procedure [dbo].[spVolumeEM_InsUpd]
	@Num_Proc_HEM	varchar(16),
	@Item_EM 	varchar(2),
	@Qtd_Vol_EM	Float, 
	@Embalagem	varchar(30),
	@Compr_EM	Float,
	@Largura_EM	Float,
	@Altura_EM	Float,
	@Peso_Bruto_EM	Float,
	@NCM		varchar(12),
	@Marca_EM	varchar(2000),
	@Contra_Marca	varchar(2000),
	@Volume		Float,
	@Container varchar(15)
AS

BEGIN TRANSACTION

	Declare @cd_tp_embal varchar(3)
	Declare @Id_NCM	int
	Declare @Item_Cont_EM varchar(10)

	set @Item_Cont_EM = (select CH.Item_Cont_EM from Container_Hou_Exp_Mar CH
						Join Container_Mas_Exp_Mar MAS on MAS.Num_Proc_MEM = CH.Num_Proc_MEM and MAS.Item_Cont_EM = CH.Item_Cont_EM
						where CH.num_proc_hEm = @Num_Proc_HEM and MAS.Num_Cont_EM = @Container)
 
	set @cd_tp_embal = (select cd_tp_embal from tipo_embalagem where nome_tp_embal = @Embalagem)
	set @Id_NCM = (select id_ncm from NCM where ncm = @NCM)

	if exists (select Item_EM from Volume_Exp_Mar where Item_EM = @Item_EM and Num_Proc_HEM = @Num_Proc_HEM)
		BEGIN
			UPDATE
				Volume_Exp_Mar
			SET
				Qtd_Vol_EM	=@Qtd_Vol_EM,
				Cd_Tp_Embal	=@Cd_Tp_Embal,
				Compr_EM	=@Compr_EM,
				Largura_EM	=@Largura_EM,
				Altura_EM	=@Altura_EM,
				Peso_Bruto_EM	=@Peso_Bruto_EM,
				Id_NCM		=@Id_NCM,
				Marca_EM	=@Marca_EM,
				Contra_Marca	=@Contra_Marca,
				Vol_Item_EM	=@Volume,
				cd_tp_unidade	='M3',
				Item_Cont_EM = @Item_Cont_EM
			WHERE
				Item_EM = @Item_EM and Num_Proc_HEM = @Num_Proc_HEM
		END
	ELSE
		BEGIN
			SET @Item_EM=(select Isnull(max(Item_EM),0)+1 from Volume_Exp_Mar where Num_Proc_HEM=@Num_Proc_HEM )
			SET @Item_EM = '0'+@Item_EM
			SET @Item_EM = right(@Item_EM,2)
			INSERT INTO
				Volume_Exp_Mar
				(
					Num_Proc_HEM,
					Item_EM,
					Qtd_Vol_EM,
					Cd_Tp_Embal,
					Compr_EM,
					Largura_EM,
					Altura_EM,
					Peso_Bruto_EM,
					Id_NCM,
					Marca_EM,
					Contra_Marca,
					Vol_Item_EM,
					cd_tp_unidade,
					Item_Cont_EM
				)
			VALUES
				(
					@Num_Proc_HEM,
					@Item_EM,
					@Qtd_Vol_EM,
					@Cd_Tp_Embal,
					@Compr_EM,
					@Largura_EM,
					@Altura_EM,
					@Peso_Bruto_EM,
					@Id_NCM,
					@Marca_EM,
					@Contra_Marca,
					@Volume,
					'M3',
					@Item_Cont_EM
				)
		END

	IF @@Error <> 0
		BEGIN
			ROLLBACK TRANSACTION
			RETURN -1
		END

COMMIT TRANSACTION
	

GO
