SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--alter table Container_Avaria add [Taxa_Indisponibilidade_Container] [varchar](500) NULL
CREATE procedure [dbo].[spATL_TermoContainer_InsUpd]

	@Codigo			bigint,
	@Job			varchar(16),
	@Dt_Termo		datetime,
	@Usuario		varchar(30),
	@BL				varchar(25),
	@Container		varchar(15),
	@Desc_Lavagem	varchar(100),
	@Valor			decimal(10,2),
	@Qty_Avaria		int,
	@Desc_Avaria	varchar(100),
	@Qty_Avaria_2	int,
	@Desc_Avaria_2	varchar(100),
	@Qty_Avaria_3	int,
	@Desc_Avaria_3	varchar(100),
	@Tp_Termo		varchar(1),
	@Nome_Armador	varchar(200),
	@Taxa_Indisponibilidade_Container		varchar(500),
	@New_Codigo		bigint output

as

	Declare @Cd_usuario		varchar(6)	
	set @Cd_usuario = (Select Cd_usuario from Usuario where Nome_Usuario = @Usuario)

If @Codigo	 is NULL or @Codigo =''
	Begin
	set @New_Codigo=(Select ISNULL(MAX(Codigo),0)  from Container_Avaria) + 1
	
		insert into Container_Avaria
		(
			Codigo,
			Num_Proc,
			Dt_Termo,
			Cd_Usuario,
			BL,
			Container,
			Desc_Lavagem,
			Valor_Termo,
			Qty_Avaria,
			Desc_Avaria,
			Qty_Avaria_2,
			Desc_Avaria_2,
			Qty_Avaria_3,
			Desc_Avaria_3,
			Tp_Termo,
			Nome_Armador,
			Taxa_Indisponibilidade_Container
		)
		values
		(
			@New_Codigo,
			@Job,
			@Dt_Termo,
			@Cd_usuario,
			@BL,
			@Container,
			@Desc_Lavagem,
			@Valor,
			@Qty_Avaria,
			@Desc_Avaria,
			@Qty_Avaria_2,
			@Desc_Avaria_2,
			@Qty_Avaria_3,
			@Desc_Avaria_3,
			@Tp_Termo,
			@Nome_Armador,
			@Taxa_Indisponibilidade_Container
		)
	End
GO
