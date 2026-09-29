SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spATL_BR_Danfe_Cia_InsUpd]
	(
	@Id_Danfe	int	,
	@Tipo	ChAR(1),
	@CNPJ	VARCHAR(14),
	@xNome	VARCHAR(60),
	@xFant	VARCHAR(60),
	@xLgr	VARCHAR(60),
	@nro	varchar(50),
	@xCpl	VARCHAR(60),
	@xBairro	VARCHAR(60),
	@cMun	VARCHAR(7),
	@xMun	VARCHAR(60),
	@UF	VARCHAR(2),
	@CEP	VARCHAR(8),
	@cPais	VARCHAR(4),
	@xPais	VARCHAR(60),
	@fone	VARCHAR(10),
	@IE	 VARCHAR(14),
	@IEST	VARCHAR(14),
	@IM		VARCHAR(15)
)

AS

BEGIN
--Exceção(try/CATCH)
--Transação
--sp_help Danfe_Base
	BEGIN TRY			
		if not exists(select id_danfe from ATL_BR.dbo.Danfe_Cia WITH(NOLOCK) where id_danfe=@id_danfe and tipo=@tipo)
			Begin
					Insert Into ATL_BR.dbo.Danfe_Cia
					(
						Id_Danfe,Tipo,CNPJ,xNome,xFant,xLgr,nro,xCpl,xBairro,cMun,xMun,
						UF,CEP,cPais,xPais,fone,IE,IEST,IM
					)
					Values
					(
						@Id_Danfe,@Tipo,@CNPJ,@xNome,@xFant,@xLgr,@nro,@xCpl,@xBairro,@cMun,@xMun,
						@UF,@CEP,@cPais,@xPais,@fone,@IE,@IEST,@IM
					)
				End
		Else
			Begin
				Update 
					ATL_BR.dbo.Danfe_Cia
				SET
					CNPJ=@CNPJ,
					xNome=@xNome,
					xFant=@xFant,
					xLgr=@xLgr,
					nro=@nro,
					xCpl=@xCpl,
					xBairro=@xBairro,
					cMun=@cMun,
					xMun=@xMun,
					UF=@UF,
					CEP=@CEP,
					cPais=@cPais,
					xPais=@xPais,
					fone=@fone,
					IE=@IE,
					IEST=@IEST,
					IM=@IM
			Where
				id_danfe=@id_danfe and Tipo=@tipo
			End		
			
		Select @Id_Danfe as Retorno;

		COMMIT TRAN
	END TRY

	BEGIN CATCH
		ROLLBACK TRAN
		SELECT ERROR_MESSAGE() as Retorno;

	END CATCH	

END


GO
