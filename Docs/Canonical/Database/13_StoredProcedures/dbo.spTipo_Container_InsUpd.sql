SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE   procedure [dbo].[spTipo_Container_InsUpd]

@Codigo		varchar(3),
@Nome		varchar(30),
@CodOf		varchar(2),
@CdSmart	varchar(4),
@CapacidadeM3 float

AS

Begin Transaction

	If  exists (select Cd_Tp_Cont from Tipo_Container where Cd_Tp_Cont=@Codigo)
	Begin
		Update
			Tipo_Container
		Set
			Cd_Tp_Cont=@Codigo,
			Nome_Tp_Cont=@Nome,
			Cd_CC_Ofc=@CodOf,
			Cd_smart =@CdSmart,
			Capacidade_M3 = @CapacidadeM3
		Where
			Cd_Tp_Cont=@Codigo
	End
	Else
		Insert
			Tipo_Container
						(
							Cd_Tp_Cont,
							Nome_Tp_Cont,
							Cd_CC_Ofc,
							Cd_Smart,
							Capacidade_M3
						)
		Values
						(
						@Codigo, 
						@Nome, 
						@CodOf,
						@CdSmart,
						@CapacidadeM3
						)
	

Commit Transaction


GO
