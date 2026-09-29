SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--SELECT DBO.fTipo_Taxa_pc('20ft - Dry Van','-','S')
--SELECT DBO.fTipo_Taxa_pc('20ft - Dry Van','-','T')


--GO

create FUNCTION [dbo].[fTipo_Taxa_pc]
(
	@Cd_Tp_Tx	varchar(3)
	,@Nome_Tp_Tx	varchar(50)
)

RETURNS VarChar(30)

AS

	BEGIN

		Declare @StrRetorno varchar(30)

		set @StrRetorno = ''

		SET @STRRETORNO = (SELECT
		
		case when 
					(
					left(@Cd_Tp_Tx,2) <> 'XB'
					or
					@Cd_Tp_Tx = 'XBB'
					or
					@Cd_Tp_Tx = 'XBF'
					or
					@Cd_Tp_Tx = 'XBQ'
					or
					@Cd_Tp_Tx = 'XBO'
					or
					@Cd_Tp_Tx = 'XBN'
					or
					@Cd_Tp_Tx = 'XBL')
				then
					case when ( left(@Cd_Tp_Tx,2) = 'X0' and left(@Nome_Tp_Tx,7) = 'Transf.' ) then
						'Adiantamentos'
					else 
						'Despesas'
					end
				else

				'Adiantamentos'

				end
		)



		Return @StrRetorno

	END


















GO
