SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spATL_Termo_Pagamento_InsUpd]
(
	@Cd_Termo			INT,
	@Descricao_Termo	varchar(200),
	@Dias				INT,
	@Dt_Base			varchar(50),
	@Mapa_ATL			varchar(500),
	@Dt_Ins				datetime,
	@Ativo				bit,
	@Cd_Usuario			varchar(10)
)

AS

Begin Transaction


	Declare @Tp_Oper char(1)
	
	If  exists (select Cd_Termo from Termo_Pagamento where Cd_Termo=@Cd_Termo)
		
		 
		Begin
			Set @Tp_Oper = 'A'
			Update
				Termo_Pagamento
			Set
				Descricao_Termo=@Descricao_Termo,
				Dias = @Dias,
				Dt_Base = @Dt_Base,
				--Mapa_ATL=@Mapa_ATL,
				Dt_Ins=@Dt_Ins,
				Ativo=@Ativo,
				Cd_Usuario=@Cd_Usuario
			Where
				Cd_Termo=@Cd_Termo
		End
	Else
		BEGIN
			set @Cd_Termo = (SELECT MIN(Cd_Termo) + 1 AS PROX_ID_LIVRE
							FROM Termo_Pagamento T
							WHERE NOT EXISTS (
							 SELECT Cd_Termo FROM Termo_Pagamento T1 
							 WHERE T1.Cd_Termo = (T.Cd_Termo + 1)))
			Insert
				Termo_Pagamento(Cd_Termo,Descricao_Termo,Dias,Dt_Base,--Mapa_ATL,
				Dt_Ins,Ativo,Cd_Usuario)
			Values
				(@Cd_Termo,@Descricao_Termo,@Dias,@Dt_Base,--@Mapa_ATL,
				@Dt_Ins,@Ativo,@Cd_Usuario)
			Set @Tp_Oper = 'I'
		End
		
	--LOG
	BEGIN
		Insert Log_Termo_Pagamento
			(Tp_Oper,Cd_Termo,Descricao_Termo,Dias,Dt_Base,--Mapa_ATL,
			Dt_Ins,Ativo,Cd_Usuario)
		Values
			(@Tp_Oper,@Cd_Termo,@Descricao_Termo,@Dias,@Dt_Base,--@Mapa_ATL,
			@Dt_Ins,@Ativo,@Cd_Usuario)
	END

Commit Transaction

GO
