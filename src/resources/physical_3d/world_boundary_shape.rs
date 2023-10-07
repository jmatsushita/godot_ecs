use godot::{engine::PhysicsServer3D, prelude::Rid};

use crate::resources::{traits::{ResourceId, CommonShape3D}, utils::macros::resource_object};

resource_object!(
    WorldBoundaryShape3D,
    world_boundary_shape_create,
    PhysicsServer3D
);

impl CommonShape3D for WorldBoundaryShape3D {}