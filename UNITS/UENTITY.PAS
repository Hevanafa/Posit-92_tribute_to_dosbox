unit UEntity;

interface

uses P92Geom;

type
  TEntityType = (
    EntityTypeNothing,

    { Format: species, class }
    EntityTypeSlimeGirl,
    EntityTypeCultist,
    EntityTypeSlimeCultist,
    EntityTypeSlimeQueen
  );

  TEntity = record
    alive: boolean;
    body: TPhysicsBody;
    entityType: TEntityType;
  end;

procedure DefaultEntity(var e: TEntity);


implementation

procedure DefaultEntity(var e: TEntity);
begin
  e.alive := false;
  e.entityType := EntityTypeNothing;

  FillChar(e.body, SizeOf(TPhysicsBody), 0)
end;

end.

